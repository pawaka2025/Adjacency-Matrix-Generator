# Adjacency Matrix Generator  

## Overview  

A high-performance library for generating randomized adjacency matrices of configurable size and density. Designed for efficiency and composability, making it ideal for graph-based computations.  

## Features  

- Generates an N × N adjacency matrix with adjustable density.  
- Uses row-based allocation (`[][]u8`) for improved composability.  
- Includes utilities for printing and deallocation.  

## Future Improvements  

- Parallelism and SIMD optimizations for faster matrix generation.  
- Further enhancements inspired by functorial compositions and inductive typing.  

## Related Work  

Inspired by ideas in functorial composition and inductive typing from my other project: [3DAlloc](https://github.com/orgs/CarbonDev/repositories).  

## Usage  

### Generating a Matrix  

```zig
const std = @import("std");
const allocator = std.heap.page_allocator;
const matrix = try generate_matrix(allocator, 1000, 0.5);
defer free_matrix(allocator, matrix);
```  

### Printing a Matrix  

```zig
print_matrix(matrix);
```   
