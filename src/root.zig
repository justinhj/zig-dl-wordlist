//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const DoublyLinkedList = std.DoublyLinkedList;

const Word = struct {
    word: []const u8,
    node: DoublyLinkedList.Node = .{},
};

const WordList = struct {
    list: std.DoublyLinkedList = .{},
    const Self = @This();

   pub fn append(self: *Self, item: *Word) void {
        self.list.append(item);
    }

    pub fn popFirst(self: *Self) ?*Word {
        if (self.list.popFirst()) |node| {
            return @fieldParentPtr("node", node);
        }
        return null;
    }

};

// Given a string parse the words and store them in a double linked list
pub fn parseWordsToDL(text: []u8) !?*WordList {
    var list: DoublyLinkedList = .{};

    var count: usize = 0;
    var it = std.mem.splitSequence(u8, text, " ");
    while(it.next()) |word| {
        count += 1;
        std.debug.print("{s}\n", .{word});
    }
    std.debug.print("Count {d}\n", .{count});
    const L = struct {
        data: u32,
        node: DoublyLinkedList.Node = .{},
    };

    var one: L = .{ .data = 1 };
    var two: L = .{ .data = 2 };
    var three: L = .{ .data = 3 };
    var four: L = .{ .data = 4 };
    var five: L = .{ .data = 5 };

    var word1: Word = .{ .word = "Field" };
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
