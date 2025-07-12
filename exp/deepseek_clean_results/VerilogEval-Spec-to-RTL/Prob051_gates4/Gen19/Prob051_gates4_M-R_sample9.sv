module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    // Alternative expression using intermediate steps
    wire and_all = in[0] & in[1] & in[2] & in[3];
    wire or_all  = in[0] | in[1] | in[2] | in[3];
    wire xor_all = in[0] ^ in[1] ^ in[2] ^ in[3];

    assign out_and = and_all;
    assign out_or  = or_all;
    assign out_xor = xor_all;
endmodule