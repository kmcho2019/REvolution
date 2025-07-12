module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with left neighbor (ignore out_both[3])
    assign out_both = {in[2] & in[3], in[1] & in[2], in[0] & in[1], 1'b0};

    // out_any: OR with right neighbor (ignore out_any[0])
    assign out_any = {1'b0, in[3] | in[2], in[2] | in[1], in[1] | in[0]};

    // out_different: XOR with left neighbor (wrap around for in[3])
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule