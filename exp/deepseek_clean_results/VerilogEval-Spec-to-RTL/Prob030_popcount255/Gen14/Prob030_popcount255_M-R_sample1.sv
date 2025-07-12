module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 5-bit chunks (51 chunks)
    wire [2:0] level1 [0:50];
    assign level1[0]  = in[0] + in[1] + in[2] + in[3] + in[4];
    assign level1[1]  = in[5] + in[6] + in[7] + in[8] + in[9];
    assign level1[2]  = in[10] + in[11] + in[12] + in[13] + in[14];
    assign level1[3]  = in[15] + in[16] + in[17] + in[18] + in[19];
    assign level1[4]  = in[20] + in[21] + in[22] + in[23] + in[24];
    assign level1[5]  = in[25] + in[26] + in[27] + in[28] + in[29];
    assign level1[6]  = in[30] + in[31] + in[32] + in[33] + in[34];
    assign level1[7]  = in[35] + in[36] + in[37] + in[38] + in[39];
    assign level1[8]  = in[40] + in[41] + in[42] + in[43] + in[44];
    assign level1[9]  = in[45] + in[46] + in[47] + in[48] + in[49];
    assign level1[10] = in[50] + in[51] + in[52] + in[53] + in[54];
    assign level1[11] = in[55] + in[56] + in[57] + in[58] + in[59];
    assign level1[12] = in[60] + in[61] + in[62] + in[63] + in[64];
    assign level1[13] = in[65] + in[66] + in[67] + in[68] + in[69];
    assign level1[14] = in[70] + in[71] + in[72] + in[73] + in[74];
    assign level1[15] = in[75] + in[76] + in[77] + in[78] + in[79];
    assign level1[16] = in[80] + in[81] + in[82] + in[83] + in[84];
    assign level1[17] = in[85] + in[86] + in[87] + in[88] + in[89];
    assign level1[18] = in[90] + in[91] + in[92] + in[93] + in[94];
    assign level1[19] = in[95] + in[96] + in[97] + in[98] + in[99];
    assign level1[20] = in[100] + in[101] + in[102] + in[103] + in[104];
    assign level1[21] = in[105] + in[106] + in[107] + in[108] + in[109];
    assign level1[22] = in[110] + in[111] + in[112] + in[113] + in[114];
    assign level1[23] = in[115] + in[116] + in[117] + in[118] + in[119];
    assign level1[24] = in[120] + in[121] + in[122] + in[123] + in[124];
    assign level1[25] = in[125] + in[126] + in[127] + in[128] + in[129];
    assign level1[26] = in[130] + in[131] + in[132] + in[133] + in[134];
    assign level1[27] = in[135] + in[136] + in[137] + in[138] + in[139];
    assign level1[28] = in[140] + in[141] + in[142] + in[143] + in[144];
    assign level1[29] = in[145] + in[146] + in[147] + in[148] + in[149];
    assign level1[30] = in[150] + in[151] + in[152] + in[153] + in[154];
    assign level1[31] = in[155] + in[156] + in[157] + in[158] + in[159];
    assign level1[32] = in[160] + in[161] + in[162] + in[163] + in[164];
    assign level1[33] = in[165] + in[166] + in[167] + in[168] + in[169];
    assign level1[34] = in[170] + in[171] + in[172] + in[173] + in[174];
    assign level1[35] = in[175] + in[176] + in[177] + in[178] + in[179];
    assign level1[36] = in[180] + in[181] + in[182] + in[183] + in[184];
    assign level1[37] = in[185] + in[186] + in[187] + in[188] + in[189];
    assign level1[38] = in[190] + in[191] + in[192] + in[193] + in[194];
    assign level1[39] = in[195] + in[196] + in[197] + in[198] + in[199];
    assign level1[40] = in[200] + in[201] + in[202] + in[203] + in[204];
    assign level1[41] = in[205] + in[206] + in[207] + in[208] + in[209];
    assign level1[42] = in[210] + in[211] + in[212] + in[213] + in[214];
    assign level1[43] = in[215] + in[216] + in[217] + in[218] + in[219];
    assign level1[44] = in[220] + in[221] + in[222] + in[223] + in[224];
    assign level1[45] = in[225] + in[226] + in[227] + in[228] + in[229];
    assign level1[46] = in[230] + in[231] + in[232] + in[233] + in[234];
    assign level1[47] = in[235] + in[236] + in[237] + in[238] + in[239];
    assign level1[48] = in[240] + in[241] + in[242] + in[243] + in[244];
    assign level1[49] = in[245] + in[246] + in[247] + in[248] + in[249];
    assign level1[50] = in[250] + in[251] + in[252] + in[253] + in[254];

    // Level 2: Sum 4 level1 counters (12 groups of 4, 3 leftovers)
    wire [4:0] level2 [0:14];
    assign level2[0] = level1[0] + level1[1] + level1[2] + level1[3];
    assign level2[1] = level1[4] + level1[5] + level1[6] + level1[7];
    assign level2[2] = level1[8] + level1[9] + level1[10] + level1[11];
    assign level2[3] = level1[12] + level1[13] + level1[14] + level1[15];
    assign level2[4] = level1[16] + level1[17] + level1[18] + level1[19];
    assign level2[5] = level1[20] + level1[21] + level1[22] + level1[23];
    assign level2[6] = level1[24] + level1[25] + level1[26] + level1[27];
    assign level2[7] = level1[28] + level1[29] + level1[30] + level1[31];
    assign level2[8] = level1[32] + level1[33] + level1[34] + level1[35];
    assign level2[9] = level1[36] + level1[37] + level1[38] + level1[39];
    assign level2[10] = level1[40] + level1[41] + level1[42] + level1[43];
    assign level2[11] = level1[44] + level1[45] + level1[46] + level1[47];
    assign level2[12] = level1[48] + level1[49] + level1[50];
    assign level2[13] = 5'b0;
    assign level2[14] = 5'b0;

    // Level 3: Sum 4 level2 counters (3 groups of 4, 2 leftovers)
    wire [6:0] level3 [0:4];
    assign level3[0] = level2[0] + level2[1] + level2[2] + level2[3];
    assign level3[1] = level2[4] + level2[5] + level2[6] + level2[7];
    assign level3[2] = level2[8] + level2[9] + level2[10] + level2[11];
    assign level3[3] = level2[12] + level2[13] + level2[14];
    assign level3[4] = 7'b0;

    // Final level: Balanced binary tree summation
    wire [7:0] sum_a = level3[0] + level3[1];
    wire [7:0] sum_b = level3[2] + level3[3];
    assign out = sum_a + sum_b;

endmodule