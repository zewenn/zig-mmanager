const std = @import("std");
const Allocator = @import("std").mem.Allocator;

const uuid = @import("uuid");

const Options = struct {
    max_items: usize = 8192,
    chunk_size: usize = 16,

    /// Maximum amount of bits that should be allocated.
    /// This is applied even if it means less items than
    /// what `max_items` specify
    max_size: usize = 8_000_000,
};

pub fn MManager(comptime T: type, comptime settings: Options) type {
    return struct {
        const Chunk = struct {
            flag: u128 = 0,
            array: [settings.chunk_size]?T = [_]?T{null} ** settings.chunk_size,
        };

        const bits_chunk_size: usize = @sizeOf(Chunk);
        const calculated_size: usize = settings.max_items * bits_chunk_size;

        const calculated_max: usize = @divFloor(settings.max_size, settings.chunk_size) * settings.chunk_size;

        const ArraySize: usize = @min(calculated_size, calculated_max);

        var array: [ArraySize]Chunk = [_]Chunk{.{}} ** ArraySize;
    };
}
