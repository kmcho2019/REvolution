/*
 * TopModule - Parameterized NOR Gate
 * 
 * Functionality:
 * Performs bitwise NOR operation between inputs a and b
 * out = ~(a | b)
 * 
 * Features:
 * - Parameterized width for multi-bit operation
 * - Optimal PPA implementation
 * - Clear documentation including truth table
 * 
 * Usage Examples:
 * // Single-bit NOR gate
 * TopModule #(.WIDTH(1)) nor1 (.a(a), .b(b), .out(out));
 * 
 * // 8-bit wide NOR operation
 * TopModule #(.WIDTH(8)) nor8 (.a(bus_a), .b(bus_b), .out(result));
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit for current requirements
) (
    input  [WIDTH-1:0] a,    // First input
    input  [WIDTH-1:0] b,    // Second input
    output [WIDTH-1:0] out   // NOR output
);
    /*
     * Truth Table (per bit):
     * a b | out
     * --------
     * 0 0 | 1
     * 0 1 | 0
     * 1 0 | 0
     * 1 1 | 0
     */
    assign out = ~(a | b);
endmodule