const std = @import("std");
const Student = @import("student.zig").Student;
const StudentManager = @import("student.zig").StudentManager;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var student_manager = try StudentManager.init(allocator);

    // Add sample data
    try student_manager.addStudent(Student.init(1, "John Doe", 20));
    try student_manager.addStudent(Student.init(2, "Jane Doe", 22));

    var server = try std.net.listen(.{
        .address = std.net.Address{ .hostname = "127.0.0.1", .port = 8080 },
    });

    defer server.close();

    while (true) {
        var conn = try server.accept();
        defer conn.close();

        var buf: [1024]u8 = undefined;
        const n = try conn.read(&buf);
        const request = std.mem.span(&buf[0..n]);

        // Simple request handling
        if (std.mem.startsWith(u8, request, "GET /students")) {
            const response = try student_manager.toJson(allocator);
            defer allocator.free(response);

            try conn.writeAll("HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n");
            try conn.writeAll(response);
        } else {
            try conn.writeAll("HTTP/1.1 404 Not Found\r\n\r\n");
        }
    }
}
