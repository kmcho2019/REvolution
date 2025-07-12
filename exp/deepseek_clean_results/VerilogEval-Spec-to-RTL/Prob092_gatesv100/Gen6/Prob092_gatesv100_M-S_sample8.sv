module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: MSB=0, others are AND with left neighbor
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: LSB=0, others are OR with right neighbor
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: XOR with circular left shift
    assign out_different = in ^ {in[0], in[99:1]};

endmodule