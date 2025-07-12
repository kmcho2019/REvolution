module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_0_1, and_2_3;
    wire or_0_1,  or_2_3;
    wire xor_0_1, xor_2_3;

    // 2-input AND gates
    assign and_0_1 = in[0] & in[1];
    assign and_2_3 = in[2] & in[3];
    assign out_and = and_0_1 & and_2_3;

    // 2-input OR gates
    assign or_0_1 = in[0] | in[1];
    assign or_2_3 = in[2] | in[3];
    assign out_or = or_0_1 | or_2_3;

    // 2-input XOR gates
    assign xor_0_1 = in[0] ^ in[1];
    assign xor_2_3 = in[2] ^ in[3];
    assign out_xor = xor_0_1 ^ xor_2_3;

endmodule