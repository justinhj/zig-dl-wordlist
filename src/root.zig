//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const DoublyLinkedList = std.DoublyLinkedList;

const WordList = struct {
    word: []const u8,
    node: DoublyLinkedList.Node = .{},
};

// Given a string parse the words and store them in a double linked list
pub fn parseWordsToDL(text: []u8) !*WordList {
    var list: DoublyLinkedList = .{};

    const it = std.mem.splitSequence(u8, text, " ,.");
    while(it.next()) |word| {
        try std.debug.print("{}", .{word});
    }

    const L = struct {
        data: u32,
        node: DoublyLinkedList.Node = .{},
    };

    var one: L = .{ .data = 1 };
    var two: L = .{ .data = 2 };
    var three: L = .{ .data = 3 };
    var four: L = .{ .data = 4 };
    var five: L = .{ .data = 5 };

    var word1: WordList = .{ .word = "Field" };
    list.append(&word1.node);

    list.append(&two.node); // {2}
    list.append(&five.node); // {2, 5}
    list.prepend(&one.node); // {1, 2, 5}
    list.insertBefore(&five.node, &four.node); // {1, 2, 4, 5}
    list.insertAfter(&two.node, &three.node); // {1, 2, 3, 4, 5}
    return null;
}


test "basic add functionality" {
    try std.testing.expect(3 + 7 == 10);
}
