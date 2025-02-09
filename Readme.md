## Adjacency Matrix Generator

**Overview**

This is a library for generating a randomized adjacency matrix of a given size and density. It is designed to be efficient and composable, making it ideal for use in graph-based computations.

**Features**

- Generates an N × N adjacency matrix with configurable density.
- Uses row-based allocation ([][]u8) for better composability.
- Fast even for large matrices (e.g., 10,000 × 10,000).
- Suitable for testing both dense and sparse graph operations.
- Includes matrix printing and deallocation functions.

**Future Improvements**

- Parallelism (Multithreading) to speed up large matrix generation.
- SIMD Optimization for vectorized operations.
- Further enhancements inspired by functorial compositions and inductive typing.

**Related Work**

This repository borrows from ideas in functorial compositions and inductive typing, as explored in my other repository: [3DAlloc](https://github.com/orgs/CarbonDev/repositories).

**Usage**

*Generating a Matrix*

const std = @import("std");
const allocator = std.heap.page_allocator;
const matrix = try generate_matrix(allocator, 1000, 0.5);
defer free_matrix(allocator, matrix);

*Printing a Matrix*

print_matrix(matrix);

**Performance**

Even without parallelism and SIMD, this library is already highly optimized, making it efficient for generating large datasets for graph computations.
