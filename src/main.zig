const std = @import("std");
const zigdl = @import("zigdl");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <filename>\n", .{args[0]});
        return error.InvalidArguments;
    }

    const filename = args[1];
    const text = try std.fs.cwd().readFileAlloc(allocator, filename, 1024 * 1024); // 1MB limit
    defer allocator.free(text);

    const word_list = try zigdl.parseWordsToDL(allocator, text);

    defer allocator.destroy(word_list);
    defer word_list.deinit();
    while (word_list.popFirst()) |first| {
        std.debug.print("Word: {s}\n", .{first.word});
        allocator.destroy(first);
    }
}
