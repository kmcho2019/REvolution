module AND_OR_XOR_Tree(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [7:0] and_level1;
    wire [3:0] and_level2;
    wire [1:0] and_level3;
    wire and_result;

    wire [7:0] or_level1;
    wire [3:0] or_level2;
    wire [1:0] or_level3;
    wire or_result;

    wire [7:0] xor_level1;
    wire [3:0] xor_level2;
    wire [1:0] xor_level3;
    wire xor_result;

    // Level 1: 8 nodes, each handling 12-13 inputs
    assign and_level1[0] = in[12] & in[11] & in[10] & in[9] & in[8] & in[7] & in[6] & in[5] & in[4] & in[3] & in[2] & in[1] & in[0];
    assign and_level1[1] = in[24] & in[23] & in[22] & in[21] & in[20] & in[19] & in[18] & in[17] & in[16] & in[15] & in[14] & in[13];
    assign and_level1[2] = in[36] & in[35] & in[34] & in[33] & in[32] & in[31] & in[30] & in[29] & in[28] & in[27] & in[26] & in[25];
    assign and_level1[3] = in[48] & in[47] & in[46] & in[45] & in[44] & in[43] & in[42] & in[41] & in[40] & in[39] & in[38] & in[37];
    assign and_level1[4] = in[60] & in[59] & in[58] & in[57] & in[56] & in[55] & in[54] & in[53] & in[52] & in[51] & in[50] & in[49];
    assign and_level1[5] = in[72] & in[71] & in[70] & in[69] & in[68] & in[67] & in[66] & in[65] & in[64] & in[63] & in[62] & in[61];
    assign and_level1[6] = in[84] & in[83] & in[82] & in[81] & in[80] & in[79] & in[78] & in[77] & in[76] & in[75] & in[74] & in[73];
    assign and_level1[7] = in[96] & in[95] & in[94] & in[93] & in[92] & in[91] & in[90] & in[89] & in[88] & in[87] & in[86] & in[85];

    assign or_level1[0] = in[12] | in[11] | in[10] | in[9] | in[8] | in[7] | in[6] | in[5] | in[4] | in[3] | in[2] | in[1] | in[0];
    assign or_level1[1] = in[24] | in[23] | in[22] | in[21] | in[20] | in[19] | in[18] | in[17] | in[16] | in[15] | in[14] | in[13];
    assign or_level1[2] = in[36] | in[35] | in[34] | in[33] | in[32] | in[31] | in[30] | in[29] | in[28] | in[27] | in[26] | in[25];
    assign or_level1[3] = in[48] | in[47] | in[46] | in[45] | in[44] | in[43] | in[42] | in[41] | in[40] | in[39] | in[38] | in[37];
    assign or_level1[4] = in[60] | in[59] | in[58] | in[57] | in[56] | in[55] | in[54] | in[53] | in[52] | in[51] | in[50] | in[49];
    assign or_level1[5] = in[72] | in[71] | in[70] | in[69] | in[68] | in[67] | in[66] | in[65] | in[64] | in[63] | in[62] | in[61];
    assign or_level1[6] = in[84] | in[83] | in[82] | in[81] | in[80] | in[79] | in[78] | in[77] | in[76] | in[75] | in[74] | in[73];
    assign or_level1[7] = in[96] | in[95] | in[94] | in[93] | in[92] | in[91] | in[90] | in[89] | in[88] | in[87] | in[86] | in[85];

    assign xor_level1[0] = in[12] ^ in[11] ^ in[10] ^ in[9] ^ in[8] ^ in[7] ^ in[6] ^ in[5] ^ in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0];
    assign xor_level1[1] = in[24] ^ in[23] ^ in[22] ^ in[21] ^ in[20] ^ in[19] ^ in[18] ^ in[17] ^ in[16] ^ in[15] ^ in[14] ^ in[13];
    assign xor_level1[2] = in[36] ^ in[35] ^ in[34] ^ in[33] ^ in[32] ^ in[31] ^ in[30] ^ in[29] ^ in[28] ^ in[27] ^ in[26] ^ in[25];
    assign xor_level1[3] = in[48] ^ in[47] ^ in[46] ^ in[45] ^ in[44] ^ in[43] ^ in[42] ^ in[41] ^ in[40] ^ in[39] ^ in[38] ^ in[37];
    assign xor_level1[4] = in[60] ^ in[59] ^ in[58] ^ in[57] ^ in[56] ^ in[55] ^ in[54] ^ in[53] ^ in[52] ^ in[51] ^ in[50] ^ in[49];
    assign xor_level1[5] = in[72] ^ in[71] ^ in[70] ^ in[69] ^ in[68] ^ in[67] ^ in[66] ^ in[65] ^ in[64] ^ in[63] ^ in[62] ^ in[61];
    assign xor_level1[6] = in[84] ^ in[83] ^ in[82] ^ in[81] ^ in[80] ^ in[79] ^ in[78] ^ in[77] ^ in[76] ^ in[75] ^ in[74] ^ in[73];
    assign xor_level1[7] = in[96] ^ in[95] ^ in[94] ^ in[93] ^ in[92] ^ in[91] ^ in[90] ^ in[89] ^ in[88] ^ in[87] ^ in[86] ^ in[85];

    // Level 2: 4 nodes, each handling 2 inputs from Level 1
    assign and_level2[0] = and_level1[0] & and_level1[1];
    assign and_level2[1] = and_level1[2] & and_level1[3];
    assign and_level2[2] = and_level1[4] & and_level1[5];
    assign and_level2[3] = and_level1[6] & and_level1[7];

    assign or_level2[0] = or_level1[0] | or_level1[1];
    assign or_level2[1] = or_level1[2] | or_level1[3];
    assign or_level2[2] = or_level1[4] | or_level1[5];
    assign or_level2[3] = or_level1[6] | or_level1[7];

    assign xor_level2[0] = xor_level1[0] ^ xor_level1[1];
    assign xor_level2[1] = xor_level1[2] ^ xor_level1[3];
    assign xor_level2[2] = xor_level1[4] ^ xor_level1[5];
    assign xor_level2[3] = xor_level1[6] ^ xor_level1[7];

    // Level 3: 2 nodes, each handling 2 inputs from Level 2
    assign and_level3[0] = and_level2[0] & and_level2[1];
    assign and_level3[1] = and_level2[2] & and_level2[3];

    assign or_level3[0] = or_level2[0] | or_level2[1];
    assign or_level3[1] = or_level2[2] | or_level2[3];

    assign xor_level3[0] = xor_level2[0] ^ xor_level2[1];
    assign xor_level3[1] = xor_level2[2] ^ xor_level2[3];

    // Final results
    assign and_result = and_level3[0] & and_level3[1];
    assign or_result = or_level3[0] | or_level3[1];
    assign xor_result = xor_level3[0] ^ xor_level3[1];

    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;

endmodule