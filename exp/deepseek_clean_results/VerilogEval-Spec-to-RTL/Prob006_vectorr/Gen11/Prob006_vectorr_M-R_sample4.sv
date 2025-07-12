/*
 * TopModule - Optimized bit reversal module with direct assignments
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 * Features:
 *   - Parameterized width for flexibility
 *   - Direct bit assignments for optimal PPA
 *   - Simplified structure without generate loop
 *   - Clean and readable implementation
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Direct bit assignments for optimal PPA and readability
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

endmodule