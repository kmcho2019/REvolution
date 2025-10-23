module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Chunking stage
    wire [31:0] chunk0;
    wire [31:0] chunk1;
    wire [31:0] chunk2;
    wire [31:0] chunk3;

    assign chunk0 = in[31:0];
    assign chunk1 = in[63:32];
    assign chunk2 = in[95:64];
    assign chunk3 = in[99:96];

    // Bitwise operation stage
    wire [31:0] and_result0;
    wire [31:0] or_result0;
    wire [31:0] xor_result0;

    wire [31:0] and_result1;
    wire [31:0] or_result1;
    wire [31:0] xor_result1;

    wire [31:0] and_result2;
    wire [31:0] or_result2;
    wire [31:0] xor_result2;

    wire [31:0] and_result3;
    wire [31:0] or_result3;
    wire [31:0] xor_result3;

    assign and_result0 = chunk0;
    assign or_result0 = chunk0;
    assign xor_result0 = chunk0;

    assign and_result1 = chunk1;
    assign or_result1 = chunk1;
    assign xor_result1 = chunk1;

    assign and_result2 = chunk2;
    assign or_result2 = chunk2;
    assign xor_result2 = chunk2;

    assign and_result3 = chunk3;
    assign or_result3 = chunk3;
    assign xor_result3 = chunk3;

    // Reduction stage
    wire and_result;
    wire or_result;
    wire xor_result;

    assign and_result = and_result0[0] & and_result1[0] & and_result2[0] & and_result3[0] &
                         and_result0[1] & and_result1[1] & and_result2[1] & and_result3[1] &
                         and_result0[2] & and_result1[2] & and_result2[2] & and_result3[2] &
                         and_result0[3] & and_result1[3] & and_result2[3] & and_result3[3] &
                         and_result0[4] & and_result1[4] & and_result2[4] & and_result3[4] &
                         and_result0[5] & and_result1[5] & and_result2[5] & and_result3[5] &
                         and_result0[6] & and_result1[6] & and_result2[6] & and_result3[6] &
                         and_result0[7] & and_result1[7] & and_result2[7] & and_result3[7] &
                         and_result0[8] & and_result1[8] & and_result2[8] & and_result3[8] &
                         and_result0[9] & and_result1[9] & and_result2[9] & and_result3[9] &
                         and_result0[10] & and_result1[10] & and_result2[10] & and_result3[10] &
                         and_result0[11] & and_result1[11] & and_result2[11] & and_result3[11] &
                         and_result0[12] & and_result1[12] & and_result2[12] & and_result3[12] &
                         and_result0[13] & and_result1[13] & and_result2[13] & and_result3[13] &
                         and_result0[14] & and_result1[14] & and_result2[14] & and_result3[14] &
                         and_result0[15] & and_result1[15] & and_result2[15] & and_result3[15] &
                         and_result0[16] & and_result1[16] & and_result2[16] & and_result3[16] &
                         and_result0[17] & and_result1[17] & and_result2[17] & and_result3[17] &
                         and_result0[18] & and_result1[18] & and_result2[18] & and_result3[18] &
                         and_result0[19] & and_result1[19] & and_result2[19] & and_result3[19] &
                         and_result0[20] & and_result1[20] & and_result2[20] & and_result3[20] &
                         and_result0[21] & and_result1[21] & and_result2[21] & and_result3[21] &
                         and_result0[22] & and_result1[22] & and_result2[22] & and_result3[22] &
                         and_result0[23] & and_result1[23] & and_result2[23] & and_result3[23] &
                         and_result0[24] & and_result1[24] & and_result2[24] & and_result3[24] &
                         and_result0[25] & and_result1[25] & and_result2[25] & and_result3[25] &
                         and_result0[26] & and_result1[26] & and_result2[26] & and_result3[26] &
                         and_result0[27] & and_result1[27] & and_result2[27] & and_result3[27] &
                         and_result0[28] & and_result1[28] & and_result2[28] & and_result3[28] &
                         and_result0[29] & and_result1[29] & and_result2[29] & and_result3[29] &
                         and_result0[30] & and_result1[30] & and_result2[30] & and_result3[30] &
                         and_result0[31] & and_result1[31] & and_result2[31] & and_result3[31];

    assign or_result = or_result0[0] | or_result1[0] | or_result2[0] | or_result3[0] |
                       or_result0[1] | or_result1[1] | or_result2[1] | or_result3[1] |
                       or_result0[2] | or_result1[2] | or_result2[2] | or_result3[2] |
                       or_result0[3] | or_result1[3] | or_result2[3] | or_result3[3] |
                       or_result0[4] | or_result1[4] | or_result2[4] | or_result3[4] |
                       or_result0[5] | or_result1[5] | or_result2[5] | or_result3[5] |
                       or_result0[6] | or_result1[6] | or_result2[6] | or_result3[6] |
                       or_result0[7] | or_result1[7] | or_result2[7] | or_result3[7] |
                       or_result0[8] | or_result1[8] | or_result2[8] | or_result3[8] |
                       or_result0[9] | or_result1[9] | or_result2[9] | or_result3[9] |
                       or_result0[10] | or_result1[10] | or_result2[10] | or_result3[10] |
                       or_result0[11] | or_result1[11] | or_result2[11] | or_result3[11] |
                       or_result0[12] | or_result1[12] | or_result2[12] | or_result3[12] |
                       or_result0[13] | or_result1[13] | or_result2[13] | or_result3[13] |
                       or_result0[14] | or_result1[14] | or_result2[14] | or_result3[14] |
                       or_result0[15] | or_result1[15] | or_result2[15] | or_result3[15] |
                       or_result0[16] | or_result1[16] | or_result2[16] | or_result3[16] |
                       or_result0[17] | or_result1[17] | or_result2[17] | or_result3[17] |
                       or_result0[18] | or_result1[18] | or_result2[18] | or_result3[18] |
                       or_result0[19] | or_result1[19] | or_result2[19] | or_result3[19] |
                       or_result0[20] | or_result1[20] | or_result2[20] | or_result3[20] |
                       or_result0[21] | or_result1[21] | or_result2[21] | or_result3[21] |
                       or_result0[22] | or_result1[22] | or_result2[22] | or_result3[22] |
                       or_result0[23] | or_result1[23] | or_result2[23] | or_result3[23] |
                       or_result0[24] | or_result1[24] | or_result2[24] | or_result3[24] |
                       or_result0[25] | or_result1[25] | or_result2[25] | or_result3[25] |
                       or_result0[26] | or_result1[26] | or_result2[26] | or_result3[26] |
                       or_result0[27] | or_result1[27] | or_result2[27] | or_result3[27] |
                       or_result0[28] | or_result1[28] | or_result2[28] | or_result3[28] |
                       or_result0[29] | or_result1[29] | or_result2[29] | or_result3[29] |
                       or_result0[30] | or_result1[30] | or_result2[30] | or_result3[30] |
                       or_result0[31] | or_result1[31] | or_result2[31] | or_result3[31];

    assign xor_result = xor_result0[0] ^ xor_result1[0] ^ xor_result2[0] ^ xor_result3[0] ^
                       xor_result0[1] ^ xor_result1[1] ^ xor_result2[1] ^ xor_result3[1] ^
                       xor_result0[2] ^ xor_result1[2] ^ xor_result2[2] ^ xor_result3[2] ^
                       xor_result0[3] ^ xor_result1[3] ^ xor_result2[3] ^ xor_result3[3] ^
                       xor_result0[4] ^ xor_result1[4] ^ xor_result2[4] ^ xor_result3[4] ^
                       xor_result0[5] ^ xor_result1[5] ^ xor_result2[5] ^ xor_result3[5] ^
                       xor_result0[6] ^ xor_result1[6] ^ xor_result2[6] ^ xor_result3[6] ^
                       xor_result0[7] ^ xor_result1[7] ^ xor_result2[7] ^ xor_result3[7] ^
                       xor_result0[8] ^ xor_result1[8] ^ xor_result2[8] ^ xor_result3[8] ^
                       xor_result0[9] ^ xor_result1[9] ^ xor_result2[9] ^ xor_result3[9] ^
                       xor_result0[10] ^ xor_result1[10] ^ xor_result2[10] ^ xor_result3[10] ^
                       xor_result0[11] ^ xor_result1[11] ^ xor_result2[11] ^ xor_result3[11] ^
                       xor_result0[12] ^ xor_result1[12] ^ xor_result2[12] ^ xor_result3[12] ^
                       xor_result0[13] ^ xor_result1[13] ^ xor_result2[13] ^ xor_result3[13] ^
                       xor_result0[14] ^ xor_result1[14] ^ xor_result2[14] ^ xor_result3[14] ^
                       xor_result0[15] ^ xor_result1[15] ^ xor_result2[15] ^ xor_result3[15] ^
                       xor_result0[16] ^ xor_result1[16] ^ xor_result2[16] ^ xor_result3[16] ^
                       xor_result0[17] ^ xor_result1[17] ^ xor_result2[17] ^ xor_result3[17] ^
                       xor_result0[18] ^ xor_result1[18] ^ xor_result2[18] ^ xor_result3[18] ^
                       xor_result0[19] ^ xor_result1[19] ^ xor_result2[19] ^ xor_result3[19] ^
                       xor_result0[20] ^ xor_result1[20] ^ xor_result2[20] ^ xor_result3[20] ^
                       xor_result0[21] ^ xor_result1[21] ^ xor_result2[21] ^ xor_result3[21] ^
                       xor_result0[22] ^ xor_result1[22] ^ xor_result2[22] ^ xor_result3[22] ^
                       xor_result0[23] ^ xor_result1[23] ^ xor_result2[23] ^ xor_result3[23] ^
                       xor_result0[24] ^ xor_result1[24] ^ xor_result2[24] ^ xor_result3[24] ^
                       xor_result0[25] ^ xor_result1[25] ^ xor_result2[25] ^ xor_result3[25] ^
                       xor_result0[26] ^ xor_result1[26] ^ xor_result2[26] ^ xor_result3[26] ^
                       xor_result0[27] ^ xor_result1[27] ^ xor_result2[27] ^ xor_result3[27] ^
                       xor_result0[28] ^ xor_result1[28] ^ xor_result2[28] ^ xor_result3[28] ^
                       xor_result0[29] ^ xor_result1[29] ^ xor_result2[29] ^ xor_result3[29] ^
                       xor_result0[30] ^ xor_result1[30] ^ xor_result2[30] ^ xor_result3[30] ^
                       xor_result0[31] ^ xor_result1[31] ^ xor_result2[31] ^ xor_result3[31];

    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;

endmodule