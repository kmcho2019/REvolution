module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: current bit AND left neighbor (out_both[3] is don't care)
    assign out_both = in & {in[3:1], 1'b0};

    // out_any: current bit OR right neighbor (out_any[0] is don't care)
    assign out_any = in | {1'b0, in[3:1]};

    // out_different: current bit XOR left neighbor (with wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule