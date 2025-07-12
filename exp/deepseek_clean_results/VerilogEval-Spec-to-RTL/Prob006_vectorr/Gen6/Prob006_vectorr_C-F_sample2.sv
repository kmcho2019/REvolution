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

    // Reverse bits using direct concatenation with systematic ordering
    assign out = {in[0], in[1], in[2], in[3], 
                 in[4], in[5], in[6], in[7]};

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