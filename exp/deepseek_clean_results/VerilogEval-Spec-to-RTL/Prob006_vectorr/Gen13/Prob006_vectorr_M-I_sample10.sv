/*
 * BitReverser - Reverses the bit order of an input vector
 * Parameters:
 *   BIT_WIDTH = 8 (default) - Specifies input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter BIT_WIDTH = 8
) (
    input [BIT_WIDTH-1:0] in,
    output [BIT_WIDTH-1:0] out
);

    // Explicit bit reversal mapping for clarity
    assign out[0] = in[7];  // MSB -> LSB
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];  // Middle bits
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];  // LSB -> MSB

endmodule

// TopModule wrapper with original interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);
    
    BitReverser #(
        .BIT_WIDTH(8)
    ) bit_reverser_inst (
        .in(in),
        .out(out)
    );

endmodule