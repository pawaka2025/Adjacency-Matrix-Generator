const std = @import("std");
const testing = std.testing;

/// Generate a random number from 1 to 9 based on density_grade.
fn  generate_scalar(density_grade: f32) u8 {
    var result: u8 = undefined;
    var rand = std.crypto.random;
    const threshold = rand.float(f32);

    if (threshold < density_grade) result = rand.intRangeAtMost(u8, 1, 9) // Generate a number
    else result = 0;

    return result;
}

/// Generate a row of random numbers with a zero at `row_index`
fn  generate_row(allocator: std.mem.Allocator, size: usize, row_index: usize, density_grade: f32) ![]u8 {
    const result = try allocator.alloc(u8, size); // Proper allocation with error propagation

    for (result) |*n | n.* = generate_scalar(density_grade);
    result[row_index] = 0;
    
    return result;
}
fn  free_row(allocator: std.mem.Allocator, array: []u8) void {
    allocator.free(array);
}

/// Primary function of this library.
/// Generates an adjacency matrix of a given size and density.
/// Ideal for generating graphs for testing both dense and sparse graph operations.
pub fn  generate_matrix(allocator: std.mem.Allocator, size: usize,density_grade: f32) ![][]u8 {
    const result = try allocator.alloc([]u8, size);
    var row_index: usize = 0;

    for (result) |*n| {
        n.* = try generate_row(allocator,size, row_index, density_grade);
        row_index = row_index + 1;
    }

    return result;
}
pub fn  free_matrix(allocator: std.mem.Allocator, matrix: [][]u8) void {
    for (matrix) |row| free_row(allocator, row);
    allocator.free(matrix);
}

fn  print_scalar(scalar: u8) void {
    std.debug.print("{d} ", .{scalar});
}
fn  print_row(row: []u8) void {
    for (row) |*n| print_scalar(n.*);
}
pub fn  print_matrix(matrix: [][]u8) void {
    for (matrix) |*n| {
        print_row(n.*);
        std.debug.print("\n", .{});
    }
}

test "generate row" {
    const allocator = testing.allocator;
    const row = try generate_row(allocator, 5, 2, 1.0);
    defer free_row(allocator, row);

    std.debug.print("\n", .{});
    print_row(row);
    try testing.expectEqual(row[2], 0); // Ensure the row_index is zero

    // Ensure other elements are within [1, 99]
    for (row, 0..) |value, index| {
        if (index != 2) {
            try testing.expect(value >= 1 and value <= 99);
        }
    }
}

test "generate_matrix" {
    const allocator = testing.allocator;
    const matrix = try generate_matrix(allocator, 10000, 11);
    defer free_matrix(allocator, matrix);

    std.debug.print("\n", .{});
    //print_matrix(matrix);
    try testing.expectEqual(matrix[2][2], 0);
}

test "generate_matrix_speed" {
    const allocator = testing.allocator;
    const start_time = std.time.nanoTimestamp(); // Start timing
    const matrix = try generate_matrix(allocator, 10000, 11);
    const end_time = std.time.nanoTimestamp(); // End timing
    defer free_matrix(allocator, matrix);

    const duration_ms = @as(f64, @floatFromInt(end_time - start_time)) / 1_000_000.0;
    std.debug.print("Matrix generation took {d:.3} ms\n", .{duration_ms});
}
