module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (in[3] is don't-care)
    assign out_both = {1'b0, in[3:1] & in[2:0]};

    // out_any: check current bit and right neighbor (in[0] is don't-care)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: check current bit and left neighbor with wrap-around
    assign out_different = in ^ {in[0], in[3:1]};

endmodule