module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire and_pair_0_1, and_pair_2_3;
    wire or_pair_0_1,  or_pair_2_3;

    // AND pairs (structural clarity)
    assign and_pair_0_1 = in[0] & in[1];
    assign and_pair_2_3 = in[2] & in[3];
    assign out_and = and_pair_0_1 & and_pair_2_3;

    // OR pairs (structural clarity)
    assign or_pair_0_1 = in[0] | in[1];
    assign or_pair_2_3 = in[2] | in[3];
    assign out_or = or_pair_0_1 | or_pair_2_3;

    // XOR using reduction operator for compactness and efficient synthesis
    assign out_xor = ^in;

endmodule