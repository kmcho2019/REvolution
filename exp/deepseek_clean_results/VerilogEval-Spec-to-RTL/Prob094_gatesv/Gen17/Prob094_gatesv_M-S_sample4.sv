module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with left neighbor (bit 3 is don't care)
    assign out_both = {3'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any: OR with right neighbor (bit 0 is don't care)
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule