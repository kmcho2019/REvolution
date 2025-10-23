/*
 * BitReverser - Reverses the bit order of an input vector
 * Parameters:
 *   WIDTH = 8 (default) - Specifies input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

endmodule

// TopModule wrapper maintains original interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);
    
    BitReverser bit_reverser_inst (
        .in(in),
        .out(out)
    );

endmodule