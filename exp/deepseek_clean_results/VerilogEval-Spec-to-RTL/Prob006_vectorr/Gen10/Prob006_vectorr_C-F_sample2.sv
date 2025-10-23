/*
 * BitReverser - Efficient parameterized bit reversal module
 * 
 * Features:
 * - Pure combinational logic for optimal timing
 * - Parameterized width with default 8-bit operation
 * - Clear documentation of bit reversal pattern
 * - Scalable implementation using generate loop
 *
 * Ports:
 *   in  - Input vector [WIDTH-1:0]
 *   out - Output vector with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Generate reversed bit connections:
    // out[0] = in[7], out[1] = in[6], ..., out[7] = in[0]
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * 
 * Ports:
 *   in  - 8-bit input vector
 *   out - 8-bit output with reversed bit order
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate the bit reverser with default width
    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule