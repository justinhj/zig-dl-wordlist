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

    if (word_list) |wl| {
        defer wl.deinit();
        defer allocator.free(wl);
        // I don't know how to iterate the list yet from the root WordList node.
        // The DoublyLinkedList is in the `node` field.
        // For now, just print the word in the returned node.
        if (wl.popFirst()) |first| {
            std.debug.print("First word: {s}\n", .{first.word});
        }
    } else {
        std.debug.print("parseWordsToDL returned null\n", .{});
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
