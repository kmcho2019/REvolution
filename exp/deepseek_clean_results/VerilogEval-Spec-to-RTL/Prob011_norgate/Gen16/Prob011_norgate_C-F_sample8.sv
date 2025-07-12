/*
 * TopModule - Optimized NOR Gate Implementation
 * 
 * Features:
 * - Direct NOR operation for optimal PPA (Power, Performance, Area)
 * - Parameterized width for multi-bit operations
 * - Comprehensive documentation including truth table
 * - Clean, readable implementation
 * 
 * Truth Table (per bit):
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 * 
 * Usage Examples:
 * // Single-bit NOR gate
 * TopModule #(.WIDTH(1)) nor_gate (.a(a), .b(b), .out(out));
 * 
 * // 4-bit wide NOR operation
 * TopModule #(.WIDTH(4)) nor4 (.a(bus_a), .b(bus_b), .out(result));
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit operation
) (
    input  [WIDTH-1:0] a,    // First input
    input  [WIDTH-1:0] b,    // Second input
    output [WIDTH-1:0] out   // NOR output
);

    // Direct NOR implementation for optimal PPA
    assign out = ~(a | b);

endmodule