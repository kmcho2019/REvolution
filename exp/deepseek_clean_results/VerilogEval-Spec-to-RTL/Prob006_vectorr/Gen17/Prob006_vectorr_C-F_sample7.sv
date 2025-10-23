/*
 * BitReverser - Parameterized bit reversal module with clear documentation
 * Features:
 *   - Pure combinational logic
 *   - Generate loop implementation for scalability
 *   - Explicit bit mapping documentation
 *   - Parameterized width (default 8)
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Generate loop creates optimal combinational logic
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

    /* Explicit bit mapping documentation for default 8-bit case:
     * out[0] = in[7]
     * out[1] = in[6]
     * out[2] = in[5]
     * out[3] = in[4]
     * out[4] = in[3]
     * out[5] = in[2]
     * out[6] = in[1]
     * out[7] = in[0]
     */

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Uses the parameterized BitReverser internally
 * Ports:
 *   in  - 8-bit input [7:0]
 *   out - 8-bit reversed output [7:0]
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule