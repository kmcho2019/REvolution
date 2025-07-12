module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = {1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};
    assign out_different = {in[3] ^ in[0], in[2] ^ in[3], in[1] ^ in[2], in[0] ^ in[1]};

endmodule