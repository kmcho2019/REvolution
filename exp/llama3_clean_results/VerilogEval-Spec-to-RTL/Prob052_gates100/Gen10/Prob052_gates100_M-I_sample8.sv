module TreeOperation(
    input  [49:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    // AND Operation
    wire [24:0] and_tree;
    assign and_tree[0] = in[0];
    assign and_tree[1] = in[1] & in[0];
    assign and_tree[2] = in[2] & and_tree[1];
    assign and_tree[3] = in[3] & and_tree[2];
    assign and_tree[4] = in[4] & and_tree[3];
    assign and_tree[5] = in[5] & and_tree[4];
    assign and_tree[6] = in[6] & and_tree[5];
    assign and_tree[7] = in[7] & and_tree[6];
    assign and_tree[8] = in[8] & and_tree[7];
    assign and_tree[9] = in[9] & and_tree[8];
    assign and_tree[10] = in[10] & and_tree[9];
    assign and_tree[11] = in[11] & and_tree[10];
    assign and_tree[12] = in[12] & and_tree[11];
    assign and_tree[13] = in[13] & and_tree[12];
    assign and_tree[14] = in[14] & and_tree[13];
    assign and_tree[15] = in[15] & and_tree[14];
    assign and_tree[16] = in[16] & and_tree[15];
    assign and_tree[17] = in[17] & and_tree[16];
    assign and_tree[18] = in[18] & and_tree[17];
    assign and_tree[19] = in[19] & and_tree[18];
    assign and_tree[20] = in[20] & and_tree[19];
    assign and_tree[21] = in[21] & and_tree[20];
    assign and_tree[22] = in[22] & and_tree[21];
    assign and_tree[23] = in[23] & and_tree[22];
    assign and_tree[24] = in[24] & and_tree[23];
    assign and_out = in[49] & in[48] & in[47] & in[46] & in[45] & in[44] & in[43] & in[42] & in[41] & in[40] & in[39] & in[38] & in[37] & in[36] & in[35] & in[34] & in[33] & in[32] & in[31] & in[30] & in[29] & in[28] & in[27] & in[26] & in[25] & and_tree[24];

    // OR Operation
    wire [24:0] or_tree;
    assign or_tree[0] = in[0];
    assign or_tree[1] = in[1] | in[0];
    assign or_tree[2] = in[2] | or_tree[1];
    assign or_tree[3] = in[3] | or_tree[2];
    assign or_tree[4] = in[4] | or_tree[3];
    assign or_tree[5] = in[5] | or_tree[4];
    assign or_tree[6] = in[6] | or_tree[5];
    assign or_tree[7] = in[7] | or_tree[6];
    assign or_tree[8] = in[8] | or_tree[7];
    assign or_tree[9] = in[9] | or_tree[8];
    assign or_tree[10] = in[10] | or_tree[9];
    assign or_tree[11] = in[11] | or_tree[10];
    assign or_tree[12] = in[12] | or_tree[11];
    assign or_tree[13] = in[13] | or_tree[12];
    assign or_tree[14] = in[14] | or_tree[13];
    assign or_tree[15] = in[15] | or_tree[14];
    assign or_tree[16] = in[16] | or_tree[15];
    assign or_tree[17] = in[17] | or_tree[16];
    assign or_tree[18] = in[18] | or_tree[17];
    assign or_tree[19] = in[19] | or_tree[18];
    assign or_tree[20] = in[20] | or_tree[19];
    assign or_tree[21] = in[21] | or_tree[20];
    assign or_tree[22] = in[22] | or_tree[21];
    assign or_tree[23] = in[23] | or_tree[22];
    assign or_tree[24] = in[24] | or_tree[23];
    assign or_out = in[49] | in[48] | in[47] | in[46] | in[45] | in[44] | in[43] | in[42] | in[41] | in[40] | in[39] | in[38] | in[37] | in[36] | in[35] | in[34] | in[33] | in[32] | in[31] | in[30] | in[29] | in[28] | in[27] | in[26] | in[25] | or_tree[24];

    // XOR Operation
    wire [24:0] xor_tree;
    assign xor_tree[0] = in[0];
    assign xor_tree[1] = in[1] ^ in[0];
    assign xor_tree[2] = in[2] ^ xor_tree[1];
    assign xor_tree[3] = in[3] ^ xor_tree[2];
    assign xor_tree[4] = in[4] ^ xor_tree[3];
    assign xor_tree[5] = in[5] ^ xor_tree[4];
    assign xor_tree[6] = in[6] ^ xor_tree[5];
    assign xor_tree[7] = in[7] ^ xor_tree[6];
    assign xor_tree[8] = in[8] ^ xor_tree[7];
    assign xor_tree[9] = in[9] ^ xor_tree[8];
    assign xor_tree[10] = in[10] ^ xor_tree[9];
    assign xor_tree[11] = in[11] ^ xor_tree[10];
    assign xor_tree[12] = in[12] ^ xor_tree[11];
    assign xor_tree[13] = in[13] ^ xor_tree[12];
    assign xor_tree[14] = in[14] ^ xor_tree[13];
    assign xor_tree[15] = in[15] ^ xor_tree[14];
    assign xor_tree[16] = in[16] ^ xor_tree[15];
    assign xor_tree[17] = in[17] ^ xor_tree[16];
    assign xor_tree[18] = in[18] ^ xor_tree[17];
    assign xor_tree[19] = in[19] ^ xor_tree[18];
    assign xor_tree[20] = in[20] ^ xor_tree[19];
    assign xor_tree[21] = in[21] ^ xor_tree[20];
    assign xor_tree[22] = in[22] ^ xor_tree[21];
    assign xor_tree[23] = in[23] ^ xor_tree[22];
    assign xor_tree[24] = in[24] ^ xor_tree[23];
    assign xor_out = in[49] ^ in[48] ^ in[47] ^ in[46] ^ in[45] ^ in[44] ^ in[43] ^ in[42] ^ in[41] ^ in[40] ^ in[39] ^ in[38] ^ in[37] ^ in[36] ^ in[35] ^ in[34] ^ in[33] ^ in[32] ^ in[31] ^ in[30] ^ in[29] ^ in[28] ^ in[27] ^ in[26] ^ in[25] ^ xor_tree[24];

endmodule

module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_result0;
    wire or_result0;
    wire xor_result0;
    wire and_result1;
    wire or_result1;
    wire xor_result1;

    TreeOperation chunk0(.in(in[49:0]),.and_out(and_result0),.or_out(or_result0),.xor_out(xor_result0));
    TreeOperation chunk1(.in(in[99:50]),.and_out(and_result1),.or_out(or_result1),.xor_out(xor_result1));

    assign out_and = and_result0 & and_result1;
    assign out_or = or_result0 | or_result1;
    assign out_xor = xor_result0 ^ xor_result1;

endmodule