/*
 * TopModule - Refactored NOR Gate Implementation
 * 
 * Features:
 * - Structural implementation showing OR followed by inversion
 * - Parameterized width for multi-bit operations
 * - Comprehensive documentation including truth table
 * - Clear separation of logical steps
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
 * // 8-bit wide NOR operation
 * TopModule #(.WIDTH(8)) nor8 (.a(bus_a), .b(bus_b), .out(result));
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit operation
) (
    input  [WIDTH-1:0] a,    // First input
    input  [WIDTH-1:0] b,    // Second input
    output [WIDTH-1:0] out   // NOR output
);

    // Internal wire for OR operation
    wire [WIDTH-1:0] or_result;
    
    // First perform OR operation
    assign or_result = a | b;
    
    // Then invert to get NOR
    assign out = ~or_result;

endmodule