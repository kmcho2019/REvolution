module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with left neighbor (MSB is 0)
    assign out_both = {1'b0, in[2:0] & in[3:1]};

    // out_any: OR with right neighbor (LSB is 0)
    assign out_any = {in[3:1] | in[2:0], 1'b0};

    // out_different: XOR with left neighbor (wrapped)
    assign out_different = in ^ {in[0], in[3:1]};

endmodule