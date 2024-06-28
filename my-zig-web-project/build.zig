const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.build_mode;
    const target = b.target;

    const exe = b.addExecutable("student-management", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();
}
