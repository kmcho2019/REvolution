module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Level 1: pairwise 2-input gates
    wire and_l1_0, and_l1_1;
    wire or_l1_0,  or_l1_1;
    wire xor_l1_0, xor_l1_1;

    assign and_l1_0 = in[0] & in[1];
    assign and_l1_1 = in[2] & in[3];

    assign or_l1_0  = in[0] | in[1];
    assign or_l1_1  = in[2] | in[3];

    assign xor_l1_0 = in[0] ^ in[1];
    assign xor_l1_1 = in[2] ^ in[3];

    // Level 2: combine results of level 1
    assign out_and = and_l1_0 & and_l1_1;
    assign out_or  = or_l1_0  | or_l1_1;
    assign out_xor = xor_l1_0 ^ xor_l1_1;
endmodule