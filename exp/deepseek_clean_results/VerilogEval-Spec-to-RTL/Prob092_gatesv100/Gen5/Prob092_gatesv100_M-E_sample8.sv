module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Circular left shift to get left neighbors
    wire [99:0] shifted_in = {in[98:0], in[99]};
    
    // Circular right shift to get right neighbors
    wire [99:0] shifted_right = {in[0], in[99:1]};

    // out_both: AND with left neighbor (circular shifted)
    assign out_both = {1'b0, in[98:0] & shifted_in[98:0]};

    // out_any: OR with right neighbor (circular shifted)
    assign out_any = {shifted_right[99:1] | in[99:1], 1'b0};

    // out_different: XOR with circular left neighbor
    assign out_different = in ^ shifted_in;

endmodule