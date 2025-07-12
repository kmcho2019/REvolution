module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: current bit AND left neighbor (out_both[3] is unused)
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: current bit OR right neighbor (out_any[0] is unused)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: current bit XOR left neighbor (with wrap-around)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule