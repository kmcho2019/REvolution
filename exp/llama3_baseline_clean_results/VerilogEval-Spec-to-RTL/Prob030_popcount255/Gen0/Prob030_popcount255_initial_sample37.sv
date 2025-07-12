module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Internal wires to connect 8-bit counters
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7,
             count8, count9, count10, count11, count12, count13, count14, count15,
             count16, count17, count18, count19, count20, count21, count22, count23,
             count24, count25, count26, count27, count28, count29, count30, count31;

    // 8-bit counters
    assign count0 = in[7:0] + 8'b0;
    assign count1 = in[15:8] + 8'b0;
    assign count2 = in[23:16] + 8'b0;
    assign count3 = in[31:24] + 8'b0;
    assign count4 = in[39:32] + 8'b0;
    assign count5 = in[47:40] + 8'b0;
    assign count6 = in[55:48] + 8'b0;
    assign count7 = in[63:56] + 8'b0;
    assign count8 = in[71:64] + 8'b0;
    assign count9 = in[79:72] + 8'b0;
    assign count10 = in[87:80] + 8'b0;
    assign count11 = in[95:88] + 8'b0;
    assign count12 = in[103:96] + 8'b0;
    assign count13 = in[111:104] + 8'b0;
    assign count14 = in[119:112] + 8'b0;
    assign count15 = in[127:120] + 8'b0;
    assign count16 = in[135:128] + 8'b0;
    assign count17 = in[143:136] + 8'b0;
    assign count18 = in[151:144] + 8'b0;
    assign count19 = in[159:152] + 8'b0;
    assign count20 = in[167:160] + 8'b0;
    assign count21 = in[175:168] + 8'b0;
    assign count22 = in[183:176] + 8'b0;
    assign count23 = in[191:184] + 8'b0;
    assign count24 = in[199:192] + 8'b0;
    assign count25 = in[207:200] + 8'b0;
    assign count26 = in[215:208] + 8'b0;
    assign count27 = in[223:216] + 8'b0;
    assign count28 = in[231:224] + 8'b0;
    assign count29 = in[239:232] + 8'b0;
    assign count30 = in[247:240] + 8'b0;
    assign count31 = in[254:248] + 8'b0;

    // Population count of each byte
    assign count0 = {8{1'b0}} + (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7]);
    assign count1 = {8{1'b0}} + (in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15]);
    assign count2 = {8{1'b0}} + (in[16] + in[17] + in[18] + in[19] + in[20] + in[21] + in[22] + in[23]);
    assign count3 = {8{1'b0}} + (in[24] + in[25] + in[26] + in[27] + in[28] + in[29] + in[30] + in[31]);
    assign count4 = {8{1'b0}} + (in[32] + in[33] + in[34] + in[35] + in[36] + in[37] + in[38] + in[39]);
    assign count5 = {8{1'b0}} + (in[40] + in[41] + in[42] + in[43] + in[44] + in[45] + in[46] + in[47]);
    assign count6 = {8{1'b0}} + (in[48] + in[49] + in[50] + in[51] + in[52] + in[53] + in[54] + in[55]);
    assign count7 = {8{1'b0}} + (in[56] + in[57] + in[58] + in[59] + in[60] + in[61] + in[62] + in[63]);
    assign count8 = {8{1'b0}} + (in[64] + in[65] + in[66] + in[67] + in[68] + in[69] + in[70] + in[71]);
    assign count9 = {8{1'b0}} + (in[72] + in[73] + in[74] + in[75] + in[76] + in[77] + in[78] + in[79]);
    assign count10 = {8{1'b0}} + (in[80] + in[81] + in[82] + in[83] + in[84] + in[85] + in[86] + in[87]);
    assign count11 = {8{1'b0}} + (in[88] + in[89] + in[90] + in[91] + in[92] + in[93] + in[94] + in[95]);
    assign count12 = {8{1'b0}} + (in[96] + in[97] + in[98] + in[99] + in[100] + in[101] + in[102] + in[103]);
    assign count13 = {8{1'b0}} + (in[104] + in[105] + in[106] + in[107] + in[108] + in[109] + in[110] + in[111]);
    assign count14 = {8{1'b0}} + (in[112] + in[113] + in[114] + in[115] + in[116] + in[117] + in[118] + in[119]);
    assign count15 = {8{1'b0}} + (in[120] + in[121] + in[122] + in[123] + in[124] + in[125] + in[126] + in[127]);
    assign count16 = {8{1'b0}} + (in[128] + in[129] + in[130] + in[131] + in[132] + in[133] + in[134] + in[135]);
    assign count17 = {8{1'b0}} + (in[136] + in[137] + in[138] + in[139] + in[140] + in[141] + in[142] + in[143]);
    assign count18 = {8{1'b0}} + (in[144] + in[145] + in[146] + in[147] + in[148] + in[149] + in[150] + in[151]);
    assign count19 = {8{1'b0}} + (in[152] + in[153] + in[154] + in[155] + in[156] + in[157] + in[158] + in[159]);
    assign count20 = {8{1'b0}} + (in[160] + in[161] + in[162] + in[163] + in[164] + in[165] + in[166] + in[167]);
    assign count21 = {8{1'b0}} + (in[168] + in[169] + in[170] + in[171] + in[172] + in[173] + in[174] + in[175]);
    assign count22 = {8{1'b0}} + (in[176] + in[177] + in[178] + in[179] + in[180] + in[181] + in[182] + in[183]);
    assign count23 = {8{1'b0}} + (in[184] + in[185] + in[186] + in[187] + in[188] + in[189] + in[190] + in[191]);
    assign count24 = {8{1'b0}} + (in[192] + in[193] + in[194] + in[195] + in[196] + in[197] + in[198] + in[199]);
    assign count25 = {8{1'b0}} + (in[200] + in[201] + in[202] + in[203] + in[204] + in[205] + in[206] + in[207]);
    assign count26 = {8{1'b0}} + (in[208] + in[209] + in[210] + in[211] + in[212] + in[213] + in[214] + in[215]);
    assign count27 = {8{1'b0}} + (in[216] + in[217] + in[218] + in[219] + in[220] + in[221] + in[222] + in[223]);
    assign count28 = {8{1'b0}} + (in[224] + in[225] + in[226] + in[227] + in[228] + in[229] + in[230] + in[231]);
    assign count29 = {8{1'b0}} + (in[232] + in[233] + in[234] + in[235] + in[236] + in[237] + in[238] + in[239]);
    assign count30 = {8{1'b0}} + (in[240] + in[241] + in[242] + in[243] + in[244] + in[245] + in[246] + in[247]);
    assign count31 = {8{1'b0}} + (in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254] + 1'b0);

    // Sum up the counts
    assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 +
                 count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15 +
                 count16 + count17 + count18 + count19 + count20 + count21 + count22 + count23 +
                 count24 + count25 + count26 + count27 + count28 + count29 + count30 + count31;

endmodule