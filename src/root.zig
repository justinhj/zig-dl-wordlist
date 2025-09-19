//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const DoublyLinkedList = std.DoublyLinkedList;

const Word = struct {
    word: []const u8,
    node: DoublyLinkedList.Node = .{},
};

const WordList = struct {
    list: std.DoublyLinkedList = .{},
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        return .{ .allocator = allocator };
    }

    pub fn deinit(self: *Self) void {
        while (self.list.popFirst()) |node| {
            const ptr: *Word = @fieldParentPtr("node", node);
            self.allocator.destroy(ptr);
        }
    }

    pub fn append(self: *Self, item: *Word) void {
        self.list.append(&item.node);
    }

    pub fn popFirst(self: *Self) ?*Word {
        if (self.list.popFirst()) |node| {
            return @fieldParentPtr("node", node);
        }
        return null;
    }
};

// Given a string parse the words and store them in a double linked list
pub fn parseWordsToDL(allocator: std.mem.Allocator, text: []u8) !?*WordList {
    const list = try allocator.create(WordList);
    list.* = WordList.init(allocator);

    var count: usize = 0;
    var it = std.mem.splitSequence(u8, text, " ");
    while (it.next()) |word| {
        count += 1;
        const word_ptr = try allocator.create(Word);
        word_ptr.* = Word{ .word = word };
        std.debug.print("{s}\n", .{word});
        list.append(word_ptr);
    }
    std.debug.print("Count {d}\n", .{count});

    return list;
}
