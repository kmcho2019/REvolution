module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 32 groups of 8 bits each,
    // last group padded with one zero bit to 8 bits (only 7 valid bits)
    // Each 8-bit group popcount by direct addition of bits (no loops, explicit sum)
    wire [3:0] pc8 [31:0];

    // Group 0: in[7:0]
    assign pc8[0] = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
    // Group 1: in[15:8]
    assign pc8[1] = in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];
    // Group 2: in[23:16]
    assign pc8[2] = in[16] + in[17] + in[18] + in[19] + in[20] + in[21] + in[22] + in[23];
    // Group 3: in[31:24]
    assign pc8[3] = in[24] + in[25] + in[26] + in[27] + in[28] + in[29] + in[30] + in[31];
    // Group 4: in[39:32]
    assign pc8[4] = in[32] + in[33] + in[34] + in[35] + in[36] + in[37] + in[38] + in[39];
    // Group 5: in[47:40]
    assign pc8[5] = in[40] + in[41] + in[42] + in[43] + in[44] + in[45] + in[46] + in[47];
    // Group 6: in[55:48]
    assign pc8[6] = in[48] + in[49] + in[50] + in[51] + in[52] + in[53] + in[54] + in[55];
    // Group 7: in[63:56]
    assign pc8[7] = in[56] + in[57] + in[58] + in[59] + in[60] + in[61] + in[62] + in[63];
    // Group 8: in[71:64]
    assign pc8[8] = in[64] + in[65] + in[66] + in[67] + in[68] + in[69] + in[70] + in[71];
    // Group 9: in[79:72]
    assign pc8[9] = in[72] + in[73] + in[74] + in[75] + in[76] + in[77] + in[78] + in[79];
    // Group 10: in[87:80]
    assign pc8[10] = in[80] + in[81] + in[82] + in[83] + in[84] + in[85] + in[86] + in[87];
    // Group 11: in[95:88]
    assign pc8[11] = in[88] + in[89] + in[90] + in[91] + in[92] + in[93] + in[94] + in[95];
    // Group 12: in[103:96]
    assign pc8[12] = in[96] + in[97] + in[98] + in[99] + in[100] + in[101] + in[102] + in[103];
    // Group 13: in[111:104]
    assign pc8[13] = in[104] + in[105] + in[106] + in[107] + in[108] + in[109] + in[110] + in[111];
    // Group 14: in[119:112]
    assign pc8[14] = in[112] + in[113] + in[114] + in[115] + in[116] + in[117] + in[118] + in[119];
    // Group 15: in[127:120]
    assign pc8[15] = in[120] + in[121] + in[122] + in[123] + in[124] + in[125] + in[126] + in[127];
    // Group 16: in[135:128]
    assign pc8[16] = in[128] + in[129] + in[130] + in[131] + in[132] + in[133] + in[134] + in[135];
    // Group 17: in[143:136]
    assign pc8[17] = in[136] + in[137] + in[138] + in[139] + in[140] + in[141] + in[142] + in[143];
    // Group 18: in[151:144]
    assign pc8[18] = in[144] + in[145] + in[146] + in[147] + in[148] + in[149] + in[150] + in[151];
    // Group 19: in[159:152]
    assign pc8[19] = in[152] + in[153] + in[154] + in[155] + in[156] + in[157] + in[158] + in[159];
    // Group 20: in[167:160]
    assign pc8[20] = in[160] + in[161] + in[162] + in[163] + in[164] + in[165] + in[166] + in[167];
    // Group 21: in[175:168]
    assign pc8[21] = in[168] + in[169] + in[170] + in[171] + in[172] + in[173] + in[174] + in[175];
    // Group 22: in[183:176]
    assign pc8[22] = in[176] + in[177] + in[178] + in[179] + in[180] + in[181] + in[182] + in[183];
    // Group 23: in[191:184]
    assign pc8[23] = in[184] + in[185] + in[186] + in[187] + in[188] + in[189] + in[190] + in[191];
    // Group 24: in[199:192]
    assign pc8[24] = in[192] + in[193] + in[194] + in[195] + in[196] + in[197] + in[198] + in[199];
    // Group 25: in[207:200]
    assign pc8[25] = in[200] + in[201] + in[202] + in[203] + in[204] + in[205] + in[206] + in[207];
    // Group 26: in[215:208]
    assign pc8[26] = in[208] + in[209] + in[210] + in[211] + in[212] + in[213] + in[214] + in[215];
    // Group 27: in[223:216]
    assign pc8[27] = in[216] + in[217] + in[218] + in[219] + in[220] + in[221] + in[222] + in[223];
    // Group 28: in[231:224]
    assign pc8[28] = in[224] + in[225] + in[226] + in[227] + in[228] + in[229] + in[230] + in[231];
    // Group 29: in[239:232]
    assign pc8[29] = in[232] + in[233] + in[234] + in[235] + in[236] + in[237] + in[238] + in[239];
    // Group 30: in[247:240]
    assign pc8[30] = in[240] + in[241] + in[242] + in[243] + in[244] + in[245] + in[246] + in[247];
    // Group 31: in[254:248] padded with one zero bit at MSB
    assign pc8[31] = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254] + 1'b0;

    // Now sum the 32 4-bit values in a balanced binary tree fashion

    // Level 1: sum pairs (4-bit + 4-bit = 5-bit)
    wire [4:0] sum_l1 [15:0];
    assign sum_l1[ 0] = pc8[ 0] + pc8[ 1];
    assign sum_l1[ 1] = pc8[ 2] + pc8[ 3];
    assign sum_l1[ 2] = pc8[ 4] + pc8[ 5];
    assign sum_l1[ 3] = pc8[ 6] + pc8[ 7];
    assign sum_l1[ 4] = pc8[ 8] + pc8[ 9];
    assign sum_l1[ 5] = pc8[10] + pc8[11];
    assign sum_l1[ 6] = pc8[12] + pc8[13];
    assign sum_l1[ 7] = pc8[14] + pc8[15];
    assign sum_l1[ 8] = pc8[16] + pc8[17];
    assign sum_l1[ 9] = pc8[18] + pc8[19];
    assign sum_l1[10] = pc8[20] + pc8[21];
    assign sum_l1[11] = pc8[22] + pc8[23];
    assign sum_l1[12] = pc8[24] + pc8[25];
    assign sum_l1[13] = pc8[26] + pc8[27];
    assign sum_l1[14] = pc8[28] + pc8[29];
    assign sum_l1[15] = pc8[30] + pc8[31];

    // Level 2: sum pairs (5-bit + 5-bit = 6-bit)
    wire [5:0] sum_l2 [7:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];
    assign sum_l2[4] = sum_l1[8] + sum_l1[9];
    assign sum_l2[5] = sum_l1[10] + sum_l1[11];
    assign sum_l2[6] = sum_l1[12] + sum_l1[13];
    assign sum_l2[7] = sum_l1[14] + sum_l1[15];

    // Level 3: sum pairs (6-bit + 6-bit = 7-bit)
    wire [6:0] sum_l3 [3:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];
    assign sum_l3[2] = sum_l2[4] + sum_l2[5];
    assign sum_l3[3] = sum_l2[6] + sum_l2[7];

    // Level 4: sum pairs (7-bit + 7-bit = 8-bit)
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: final sum (8-bit + 8-bit = 8-bit output, 255 max fits in 8 bits)
    assign out = sum_l4[0] + sum_l4[1];
endmodule