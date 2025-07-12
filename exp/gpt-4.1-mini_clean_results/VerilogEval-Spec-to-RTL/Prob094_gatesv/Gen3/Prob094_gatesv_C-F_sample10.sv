module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: bit and its left neighbor (higher index)
    assign out_both = {1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};

    // out_any: bit or its right neighbor (lower index)
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different: bit xor with left neighbor with wrap-around (neighbor of in[3] is in[0])
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];

endmodule