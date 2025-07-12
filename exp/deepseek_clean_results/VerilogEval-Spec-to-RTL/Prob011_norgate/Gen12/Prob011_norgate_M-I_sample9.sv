/*
 * Parameterized NOR Gate Module
 * Implements logical NOR operation between inputs a and b
 * Can be easily scaled to wider inputs by changing WIDTH parameter
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