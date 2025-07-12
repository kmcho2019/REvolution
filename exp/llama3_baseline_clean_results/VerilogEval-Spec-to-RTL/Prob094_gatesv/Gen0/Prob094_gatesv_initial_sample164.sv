module TopModule(
    input [3:0] in,
    output [3:1] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

    // Generate out_both
    assign out_both[3:1] = {in[3] & in[2], in[2] & in[1], in[1] & in[0]};

    // Generate out_any
    assign out_any[2:0] = {in[2] | in[1], in[1] | in[0], in[0] | in[3]};

    // Generate out_different
    assign out_different[3:0] = {in[3] ^ in[0], in[0] ^ in[1], in[1] ^ in[2], in[2] ^ in[3]};

endmodule