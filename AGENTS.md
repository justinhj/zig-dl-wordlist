# Agent Guidelines for zigdl

## Build/Test Commands
- **Build**: `zig build`
- **Run**: `zig build run`
- **Test**: `zig build test`
- **Check compile**: `zig build check`
- **Install**: `zig build` (outputs to zig-out/)

## Code Style Guidelines

### Naming Conventions
- Functions: `snake_case` (e.g., `parseWordsToDL`)
- Types/Structs: `PascalCase` (e.g., `WordList`, `Word`)
- Variables: `snake_case` (e.g., `word_list`, `allocator`)
- Constants: `SCREAMING_SNAKE_CASE` when needed

### Imports and Dependencies
- Use `const std = @import("std");` for standard library
- Import local modules with descriptive names: `const zigdl = @import("zigdl");`
- Group imports at the top of files

### Memory Management
- Use `std.mem.Allocator` for all allocations
- Always use `defer` for cleanup (e.g., `defer allocator.free(text);`)
- Use `defer _ = gpa.deinit();` for GPA cleanup
- Prefer `allocator.create()` and `allocator.destroy()` for single objects

### Error Handling
- Use `!` return type for functions that can fail
- Use `try` for error propagation
- Return meaningful error types (e.g., `error.InvalidArguments`)

### Data Structures
- Use `std.DoublyLinkedList` for linked structures
- Use `@fieldParentPtr` for intrusive containers
- Define `const Self = @This();` for self-referencing structs

### Code Organization
- Use `pub` for public API functions/structs
- Group related functionality in structs
- Use struct initialization syntax: `.{}`
- Prefer `const` over `var` when possible

### Formatting
- Use 4-space indentation (Zig default)
- Use `std.debug.print` for debug output
- Keep lines under 100 characters when possible