module TopModule(
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out   // 8-bit output
);

    // Define intermediate wires
    wire [7:0] count0;  // Count for bits 0-7
    wire [7:0] count1;  // Count for bits 8-15
    wire [7:0] count2;  // Count for bits 16-23
    wire [7:0] count3;  // Count for bits 24-31
    wire [7:0] count4;  // Count for bits 32-39
    wire [7:0] count5;  // Count for bits 40-47
    wire [7:0] count6;  // Count for bits 48-55
    wire [7:0] count7;  // Count for bits 56-63
    wire [7:0] count8;  // Count for bits 64-71
    wire [7:0] count9;  // Count for bits 72-79
    wire [7:0] count10;  // Count for bits 80-87
    wire [7:0] count11;  // Count for bits 88-95
    wire [7:0] count12;  // Count for bits 96-103
    wire [7:0] count13;  // Count for bits 104-111
    wire [7:0] count14;  // Count for bits 112-119
    wire [7:0] count15;  // Count for bits 120-127
    wire [7:0] count16;  // Count for bits 128-135
    wire [7:0] count17;  // Count for bits 136-143
    wire [7:0] count18;  // Count for bits 144-151
    wire [7:0] count19;  // Count for bits 152-159
    wire [7:0] count20;  // Count for bits 160-167
    wire [7:0] count21;  // Count for bits 168-175
    wire [7:0] count22;  // Count for bits 176-183
    wire [7:0] count23;  // Count for bits 184-191
    wire [7:0] count24;  // Count for bits 192-199
    wire [7:0] count25;  // Count for bits 200-207
    wire [7:0] count26;  // Count for bits 208-215
    wire [7:0] count27;  // Count for bits 216-223
    wire [7:0] count28;  // Count for bits 224-231
    wire [7:0] count29;  // Count for bits 232-239
    wire [7:0] count30;  // Count for bits 240-247
    wire [7:0] count31;  // Count for bits 248-255

    // Count the number of '1's in each 8-bit segment
    assign count0 = {8{1'b0}} + in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
    assign count1 = {8{1'b0}} + in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];
    assign count2 = {8{1'b0}} + in[16] + in[17] + in[18] + in[19] + in[20] + in[21] + in[22] + in[23];
    assign count3 = {8{1'b0}} + in[24] + in[25] + in[26] + in[27] + in[28] + in[29] + in[30] + in[31];
    assign count4 = {8{1'b0}} + in[32] + in[33] + in[34] + in[35] + in[36] + in[37] + in[38] + in[39];
    assign count5 = {8{1'b0}} + in[40] + in[41] + in[42] + in[43] + in[44] + in[45] + in[46] + in[47];
    assign count6 = {8{1'b0}} + in[48] + in[49] + in[50] + in[51] + in[52] + in[53] + in[54] + in[55];
    assign count7 = {8{1'b0}} + in[56] + in[57] + in[58] + in[59] + in[60] + in[61] + in[62] + in[63];
    assign count8 = {8{1'b0}} + in[64] + in[65] + in[66] + in[67] + in[68] + in[69] + in[70] + in[71];
    assign count9 = {8{1'b0}} + in[72] + in[73] + in[74] + in[75] + in[76] + in[77] + in[78] + in[79];
    assign count10 = {8{1'b0}} + in[80] + in[81] + in[82] + in[83] + in[84] + in[85] + in[86] + in[87];
    assign count11 = {8{1'b0}} + in[88] + in[89] + in[90] + in[91] + in[92] + in[93] + in[94] + in[95];
    assign count12 = {8{1'b0}} + in[96] + in[97] + in[98] + in[99] + in[100] + in[101] + in[102] + in[103];
    assign count13 = {8{1'b0}} + in[104] + in[105] + in[106] + in[107] + in[108] + in[109] + in[110] + in[111];
    assign count14 = {8{1'b0}} + in[112] + in[113] + in[114] + in[115] + in[116] + in[117] + in[118] + in[119];
    assign count15 = {8{1'b0}} + in[120] + in[121] + in[122] + in[123] + in[124] + in[125] + in[126] + in[127];
    assign count16 = {8{1'b0}} + in[128] + in[129] + in[130] + in[131] + in[132] + in[133] + in[134] + in[135];
    assign count17 = {8{1'b0}} + in[136] + in[137] + in[138] + in[139] + in[140] + in[141] + in[142] + in[143];
    assign count18 = {8{1'b0}} + in[144] + in[145] + in[146] + in[147] + in[148] + in[149] + in[150] + in[151];
    assign count19 = {8{1'b0}} + in[152] + in[153] + in[154] + in[155] + in[156] + in[157] + in[158] + in[159];
    assign count20 = {8{1'b0}} + in[160] + in[161] + in[162] + in[163] + in[164] + in[165] + in[166] + in[167];
    assign count21 = {8{1'b0}} + in[168] + in[169] + in[170] + in[171] + in[172] + in[173] + in[174] + in[175];
    assign count22 = {8{1'b0}} + in[176] + in[177] + in[178] + in[179] + in[180] + in[181] + in[182] + in[183];
    assign count23 = {8{1'b0}} + in[184] + in[185] + in[186] + in[187] + in[188] + in[189] + in[190] + in[191];
    assign count24 = {8{1'b0}} + in[192] + in[193] + in[194] + in[195] + in[196] + in[197] + in[198] + in[199];
    assign count25 = {8{1'b0}} + in[200] + in[201] + in[202] + in[203] + in[204] + in[205] + in[206] + in[207];
    assign count26 = {8{1'b0}} + in[208] + in[209] + in[210] + in[211] + in[212] + in[213] + in[214] + in[215];
    assign count27 = {8{1'b0}} + in[216] + in[217] + in[218] + in[219] + in[220] + in[221] + in[222] + in[223];
    assign count28 = {8{1'b0}} + in[224] + in[225] + in[226] + in[227] + in[228] + in[229] + in[230] + in[231];
    assign count29 = {8{1'b0}} + in[232] + in[233] + in[234] + in[235] + in[236] + in[237] + in[238] + in[239];
    assign count30 = {8{1'b0}} + in[240] + in[241] + in[242] + in[243] + in[244] + in[245] + in[246] + in[247];
    assign count31 = {8{1'b0}} + in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254] + in[255];

    // Sum up the counts
    assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15 + count16 + count17 + count18 + count19 + count20 + count21 + count22 + count23 + count24 + count25 + count26 + count27 + count28 + count29 + count30 + count31;

endmodule