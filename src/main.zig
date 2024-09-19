const std = @import("std");

const mmanager = @import("mlist.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const alloc = gpa.allocator();

    var list = try mmanager.mList(i32, .{
        .allow_out_of_bounds_indexing = true,
    }).init(alloc);
    defer list.deinit();

    _ = try list.append(32);
    std.log.debug("Slice: {any}", .{list.slice});

    _ = try list.append(320);
    std.log.debug("Slice: {any}", .{list.slice});

    for (0..80) |x| {
        _ = try list.append(@intCast(x));

        if (x > 20) {
            const rm = std.crypto.random.intRangeLessThan(
                usize,
                0,
                list.len(),
            );
            try list.remove(rm);
        }

        std.log.debug("Slice: {any}", .{list.slice});
    }

    if (list.getPtr(10)) |p| {
        p.* = 4444;
    }

    try list.remove(1);
    try list.remove(2);
    std.log.debug("Slice: {any}", .{list.slice});
}
