module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND with left neighbor (bit 99 = 0)
    assign out_both[99] = 1'b0;
    assign out_both[98:0] = in[98:0] & in[99:1];

    // out_any: OR with right neighbor (bit 0 = 0)
    assign out_any[0] = 1'b0;
    assign out_any[99:1] = in[99:1] | in[98:0];

    // out_different: XOR with left neighbor (wrapped)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule