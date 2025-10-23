module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: special case for MSB, then AND with left neighbor
    assign out_both = {1'b0, in[99:1] & in[98:0]};

    // out_any: special case for LSB, then OR with right neighbor
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: XOR with left neighbor (wrap-around)
    assign out_different = in ^ {in[0], in[99:1]};

endmodule