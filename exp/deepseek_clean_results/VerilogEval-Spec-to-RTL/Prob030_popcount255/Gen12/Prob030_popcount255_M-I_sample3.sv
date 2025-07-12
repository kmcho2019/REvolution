module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Count 1s in 8-bit chunks (3-bit results)
    wire [2:0] count_0_7   = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
    wire [2:0] count_8_15  = in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];
    wire [2:0] count_16_23 = in[16] + in[17] + in[18] + in[19] + in[20] + in[21] + in[22] + in[23];
    wire [2:0] count_24_31 = in[24] + in[25] + in[26] + in[27] + in[28] + in[29] + in[30] + in[31];
    wire [2:0] count_32_39 = in[32] + in[33] + in[34] + in[35] + in[36] + in[37] + in[38] + in[39];
    wire [2:0] count_40_47 = in[40] + in[41] + in[42] + in[43] + in[44] + in[45] + in[46] + in[47];
    wire [2:0] count_48_55 = in[48] + in[49] + in[50] + in[51] + in[52] + in[53] + in[54] + in[55];
    wire [2:0] count_56_63 = in[56] + in[57] + in[58] + in[59] + in[60] + in[61] + in[62] + in[63];
    wire [2:0] count_64_71 = in[64] + in[65] + in[66] + in[67] + in[68] + in[69] + in[70] + in[71];
    wire [2:0] count_72_79 = in[72] + in[73] + in[74] + in[75] + in[76] + in[77] + in[78] + in[79];
    wire [2:0] count_80_87 = in[80] + in[81] + in[82] + in[83] + in[84] + in[85] + in[86] + in[87];
    wire [2:0] count_88_95 = in[88] + in[89] + in[90] + in[91] + in[92] + in[93] + in[94] + in[95];
    wire [2:0] count_96_103 = in[96] + in[97] + in[98] + in[99] + in[100] + in[101] + in[102] + in[103];
    wire [2:0] count_104_111 = in[104] + in[105] + in[106] + in[107] + in[108] + in[109] + in[110] + in[111];
    wire [2:0] count_112_119 = in[112] + in[113] + in[114] + in[115] + in[116] + in[117] + in[118] + in[119];
    wire [2:0] count_120_127 = in[120] + in[121] + in[122] + in[123] + in[124] + in[125] + in[126] + in[127];
    wire [2:0] count_128_135 = in[128] + in[129] + in[130] + in[131] + in[132] + in[133] + in[134] + in[135];
    wire [2:0] count_136_143 = in[136] + in[137] + in[138] + in[139] + in[140] + in[141] + in[142] + in[143];
    wire [2:0] count_144_151 = in[144] + in[145] + in[146] + in[147] + in[148] + in[149] + in[150] + in[151];
    wire [2:0] count_152_159 = in[152] + in[153] + in[154] + in[155] + in[156] + in[157] + in[158] + in[159];
    wire [2:0] count_160_167 = in[160] + in[161] + in[162] + in[163] + in[164] + in[165] + in[166] + in[167];
    wire [2:0] count_168_175 = in[168] + in[169] + in[170] + in[171] + in[172] + in[173] + in[174] + in[175];
    wire [2:0] count_176_183 = in[176] + in[177] + in[178] + in[179] + in[180] + in[181] + in[182] + in[183];
    wire [2:0] count_184_191 = in[184] + in[185] + in[186] + in[187] + in[188] + in[189] + in[190] + in[191];
    wire [2:0] count_192_199 = in[192] + in[193] + in[194] + in[195] + in[196] + in[197] + in[198] + in[199];
    wire [2:0] count_200_207 = in[200] + in[201] + in[202] + in[203] + in[204] + in[205] + in[206] + in[207];
    wire [2:0] count_208_215 = in[208] + in[209] + in[210] + in[211] + in[212] + in[213] + in[214] + in[215];
    wire [2:0] count_216_223 = in[216] + in[217] + in[218] + in[219] + in[220] + in[221] + in[222] + in[223];
    wire [2:0] count_224_231 = in[224] + in[225] + in[226] + in[227] + in[228] + in[229] + in[230] + in[231];
    wire [2:0] count_232_239 = in[232] + in[233] + in[234] + in[235] + in[236] + in[237] + in[238] + in[239];
    wire [2:0] count_240_247 = in[240] + in[241] + in[242] + in[243] + in[244] + in[245] + in[246] + in[247];
    wire [2:0] count_248_254 = in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];

    // Second level: Sum pairs of 3-bit counts (4-bit results)
    wire [3:0] sum_level1 [0:15];
    assign sum_level1[0] = count_0_7 + count_8_15;
    assign sum_level1[1] = count_16_23 + count_24_31;
    assign sum_level1[2] = count_32_39 + count_40_47;
    assign sum_level1[3] = count_48_55 + count_56_63;
    assign sum_level1[4] = count_64_71 + count_72_79;
    assign sum_level1[5] = count_80_87 + count_88_95;
    assign sum_level1[6] = count_96_103 + count_104_111;
    assign sum_level1[7] = count_112_119 + count_120_127;
    assign sum_level1[8] = count_128_135 + count_136_143;
    assign sum_level1[9] = count_144_151 + count_152_159;
    assign sum_level1[10] = count_160_167 + count_168_175;
    assign sum_level1[11] = count_176_183 + count_184_191;
    assign sum_level1[12] = count_192_199 + count_200_207;
    assign sum_level1[13] = count_208_215 + count_216_223;
    assign sum_level1[14] = count_224_231 + count_232_239;
    assign sum_level1[15] = count_240_247 + count_248_254;

    // Third level: Sum pairs of 4-bit counts (5-bit results)
    wire [4:0] sum_level2 [0:7];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];
    assign sum_level2[2] = sum_level1[4] + sum_level1[5];
    assign sum_level2[3] = sum_level1[6] + sum_level1[7];
    assign sum_level2[4] = sum_level1[8] + sum_level1[9];
    assign sum_level2[5] = sum_level1[10] + sum_level1[11];
    assign sum_level2[6] = sum_level1[12] + sum_level1[13];
    assign sum_level2[7] = sum_level1[14] + sum_level1[15];

    // Fourth level: Sum pairs of 5-bit counts (6-bit results)
    wire [5:0] sum_level3 [0:3];
    assign sum_level3[0] = sum_level2[0] + sum_level2[1];
    assign sum_level3[1] = sum_level2[2] + sum_level2[3];
    assign sum_level3[2] = sum_level2[4] + sum_level2[5];
    assign sum_level3[3] = sum_level2[6] + sum_level2[7];

    // Fifth level: Sum pairs of 6-bit counts (7-bit results)
    wire [6:0] sum_level4 [0:1];
    assign sum_level4[0] = sum_level3[0] + sum_level3[1];
    assign sum_level4[1] = sum_level3[2] + sum_level3[3];

    // Final sum (8-bit result)
    assign out = sum_level4[0] + sum_level4[1];

endmodule