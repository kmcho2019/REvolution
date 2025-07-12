/*
 * TopModule - Optimized NOR Gate Implementation
 * 
 * Functionality:
 * Performs bitwise NOR operation: out = ~(a | b)
 * 
 * Features:
 * - Parameterized width (defaults to 1-bit for optimal PPA)
 * - Direct NOR implementation for best timing
 * - Clear documentation including truth table
 * - Implementation notes for power/area tradeoffs
 * 
 * Implementation Notes:
 * - For single-bit case (WIDTH=1), this provides optimal PPA
 * - For multi-bit cases, synthesizer will create parallel gates
 * - Alternative implementation (~a & ~b) may have better power
 *   characteristics in some technologies (De Morgan's equivalent)
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
 * // Optimal single-bit NOR
 * TopModule nor_gate (.a(a), .b(b), .out(out));
 * 
 * // 4-bit wide NOR
 * TopModule #(4) bus_nor (.a(bus_a), .b(bus_b), .out(result));
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit for optimal PPA
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);
    // Direct NOR implementation for optimal PPA
    assign out = ~(a | b);
    
    /* Alternative implementation (uncomment if better PPA in your technology):
     * assign out = ~a & ~b;  // De Morgan's equivalent
     */
endmodule