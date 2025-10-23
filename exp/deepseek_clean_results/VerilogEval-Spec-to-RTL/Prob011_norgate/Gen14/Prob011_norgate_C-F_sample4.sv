/*
 * Parameterized NOR Gate Module with Procedural Implementation
 * Implements logical NOR operation between inputs a and b
 * Uses procedural assignment for consistency in larger designs
 * Can be easily scaled to wider inputs by changing WIDTH parameter
 */
module TopModule #(
    parameter WIDTH = 1  // Default to 1-bit for current requirements
) (
    input  [WIDTH-1:0] a,    // First input
    input  [WIDTH-1:0] b,    // Second input
    output reg [WIDTH-1:0] out   // NOR output
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
    always @(*) begin
        out = ~(a | b);
    end
endmodule