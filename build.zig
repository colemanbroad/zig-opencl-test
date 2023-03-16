const builtin = @import("builtin");
const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const exe = b.addExecutable(.{
        .name = "zig-opencl-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = .{},
        .optimize = .Debug,
    });
    exe.addIncludePath("./opencl-headers");
    if (builtin.os.tag == .windows) {
        std.debug.warn("Windows detected, adding default CUDA SDK x64 lib search path. Change this in build.zig if needed...");
        exe.addLibPath("C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.1/lib/x64");
    }
    exe.linkSystemLibrary("c");
    if (builtin.os.tag == .macos) {
        exe.linkFramework("OpenCL");
    } else {
        exe.linkSystemLibrary("OpenCL");
    }
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
