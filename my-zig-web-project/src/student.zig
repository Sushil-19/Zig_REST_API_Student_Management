const std = @import("std");

pub const Student = struct {
    id: u32,
    name: []const u8,
    age: u8,

    pub fn init(id: u32, name: []const u8, age: u8) Student {
        return Student{
            .id = id,
            .name = name,
            .age = age,
        };
    }

    pub fn toJson(self: *Student, allocator: *std.mem.Allocator) ![]const u8 {
        var json_allocator = std.json.Allocator.create(allocator);
        defer json_allocator.deinit();

        const writer = std.json.Writer.init(&json_allocator.allocator);
        try writer.beginObject();
        try writer.writeField("id", self.id);
        try writer.writeField("name", self.name);
        try writer.writeField("age", self.age);
        try writer.endObject();

        return writer.toOwnedSlice();
    }
};

pub const StudentManager = struct {
    students: std.ArrayList(Student),

    pub fn init(allocator: *std.mem.Allocator) !StudentManager {
        return StudentManager{
            .students = try std.ArrayList(Student).init(allocator),
        };
    }

    pub fn addStudent(self: *StudentManager, student: Student) !void {
        try self.students.append(student);
    }

    pub fn getStudent(self: *StudentManager, id: u32) ?*Student {
        for (self.students.items) |*student| {
            if (student.id == id) {
                return student;
            }
        }
        return null;
    }

    pub fn toJson(self: *StudentManager, allocator: *std.mem.Allocator) ![]const u8 {
        var json_allocator = std.json.Allocator.create(allocator);
        defer json_allocator.deinit();

        const writer = std.json.Writer.init(&json_allocator.allocator);
        try writer.beginArray();
        for (self.students.items) |student| {
            try writer.beginObject();
            try writer.writeField("id", student.id);
            try writer.writeField("name", student.name);
            try writer.writeField("age", student.age);
            try writer.endObject();
        }
        try writer.endArray();

        return writer.toOwnedSlice();
    }
};
