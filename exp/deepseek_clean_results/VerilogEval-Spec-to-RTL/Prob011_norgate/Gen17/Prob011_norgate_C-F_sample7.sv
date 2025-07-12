/*
 * TopModule - Optimized NOR Gate Implementation
 * 
 * Features:
 * - Direct NOR operation for optimal PPA (default)
 * - Optional hierarchical implementation (via `HIERARCHICAL` parameter)
 * - Parameterized width for multi-bit operations
 * - Comprehensive documentation including truth table
 * - Clean, readable implementation with examples
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
 * // Default single-bit NOR gate (direct implementation)
 * TopModule nor_gate (.a(a), .b(b), .out(out));
 * 
 * // 4-bit wide NOR operation
 * TopModule #(.WIDTH(4)) nor4 (.a(bus_a), .b(bus_b), .out(result));
 * 
 * // Hierarchical implementation (for debugging/modularity)
 * TopModule #(.HIERARCHICAL(1)) nor_debug (.a(a), .b(b), .out(out));
 */

module TopModule #(
    parameter WIDTH = 1,         // Default to 1-bit operation
    parameter HIERARCHICAL = 0   // 0=direct (default), 1=hierarchical
) (
    input  [WIDTH-1:0] a,       // First input
    input  [WIDTH-1:0] b,       // Second input
    output [WIDTH-1:0] out      // NOR output
);

generate
    if (HIERARCHICAL) begin : hierarchical_impl
        // Hierarchical implementation (OR + NOT) - better for debugging
        wire [WIDTH-1:0] or_out;
        
        // Bitwise OR operation
        assign or_out = a | b;
        
        // Bitwise NOT operation
        assign out = ~or_out;
        
    end else begin : direct_impl
        // Direct NOR implementation - optimal PPA
        assign out = ~(a | b);
    end
endgenerate

endmodule