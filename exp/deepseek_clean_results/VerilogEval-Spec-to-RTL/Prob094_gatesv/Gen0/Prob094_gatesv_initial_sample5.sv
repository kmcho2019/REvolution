module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: check current bit and left neighbor (except for in[3])
    assign out_both = {1'b0, in[3] & in[2], in[2] & in[1], in[1] & in[0]};

    // out_any: check current bit or right neighbor (except for in[0])
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different: check current bit vs left neighbor (with wrap-around)
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule