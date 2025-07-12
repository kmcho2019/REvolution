/*
 * BitReverser - Parameterized bit order reversal module
 * Description: Reverses the bit order of input vector
 * Features:
 *   - Fully parameterized width
 *   - Pure combinational logic
 *   - Scalable for any bit width
 * Parameters:
 *   WIDTH = 8 (default) - Input/output vector width
 * Ports:
 *   data_in  - Input vector to be reversed
 *   data_out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out
);

    localparam MSB = WIDTH-1;  // For clearer code

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign data_out[i] = data_in[MSB-i];
        end
    endgenerate

endmodule

// Top-level module with fixed 8-bit interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .data_in(in),
        .data_out(out)
    );

endmodule