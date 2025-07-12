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

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : reverse_bits
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

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