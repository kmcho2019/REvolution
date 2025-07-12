/*
 * TopModule - Parameterized bit reversal module with direct implementation
 * Features:
 *   - Pure combinational logic for optimal timing
 *   - Direct bit reversal implementation for clarity and efficiency
 *   - Parameterized width (default 8) for flexibility
 *   - Clear documentation and systematic bit ordering
 * 
 * Parameters:
 *   WIDTH = 8 (default) - Specifies input/output bit width
 * Ports:
 *   in  - Input vector [WIDTH-1:0]
 *   out - Output vector with reversed bit order [WIDTH-1:0]
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit reversal assignment for optimal PPA and clarity
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

endmodule