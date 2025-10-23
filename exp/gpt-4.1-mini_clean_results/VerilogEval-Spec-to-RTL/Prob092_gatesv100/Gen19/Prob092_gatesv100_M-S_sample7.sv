module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both: for bits [0:98], AND with left neighbor (i+1); bit 99 = 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any: for bits [1:99], OR with right neighbor (i-1); bit 0 = 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different: XOR with left neighbor, wrapping around (bit 99 neighbor is 0)
    assign out_different[98:0] = in[98:0] ^ in[99:1];
    assign out_different[99] = in[99] ^ in[0];

endmodule