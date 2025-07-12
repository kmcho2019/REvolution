module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: count 1's in 8-bit chunks by direct sum of bits (no function/module)
    // Last chunk has 7 bits only
    wire [3:0] chunk_pop [31:0];

    // Helper to sum bits of 8-bit vector manually without loops
    // Max count per chunk: 8, needs 4 bits.

    // Chunks 0 to 30: full 8 bits
    assign chunk_pop[0]  = in[ 7] + in[ 6] + in[ 5] + in[ 4] + in[ 3] + in[ 2] + in[ 1] + in[ 0];
    assign chunk_pop[1]  = in[15] + in[14] + in[13] + in[12] + in[11] + in[10] + in[ 9] + in[ 8];
    assign chunk_pop[2]  = in[23] + in[22] + in[21] + in[20] + in[19] + in[18] + in[17] + in[16];
    assign chunk_pop[3]  = in[31] + in[30] + in[29] + in[28] + in[27] + in[26] + in[25] + in[24];
    assign chunk_pop[4]  = in[39] + in[38] + in[37] + in[36] + in[35] + in[34] + in[33] + in[32];
    assign chunk_pop[5]  = in[47] + in[46] + in[45] + in[44] + in[43] + in[42] + in[41] + in[40];
    assign chunk_pop[6]  = in[55] + in[54] + in[53] + in[52] + in[51] + in[50] + in[49] + in[48];
    assign chunk_pop[7]  = in[63] + in[62] + in[61] + in[60] + in[59] + in[58] + in[57] + in[56];
    assign chunk_pop[8]  = in[71] + in[70] + in[69] + in[68] + in[67] + in[66] + in[65] + in[64];
    assign chunk_pop[9]  = in[79] + in[78] + in[77] + in[76] + in[75] + in[74] + in[73] + in[72];
    assign chunk_pop[10] = in[87] + in[86] + in[85] + in[84] + in[83] + in[82] + in[81] + in[80];
    assign chunk_pop[11] = in[95] + in[94] + in[93] + in[92] + in[91] + in[90] + in[89] + in[88];
    assign chunk_pop[12] = in[103]+ in[102]+ in[101]+ in[100]+  in[99]+  in[98]+  in[97]+  in[96];
    assign chunk_pop[13] = in[111]+ in[110]+ in[109]+ in[108]+  in[107]+ in[106]+ in[105]+ in[104];
    assign chunk_pop[14] = in[119]+ in[118]+ in[117]+ in[116]+  in[115]+ in[114]+ in[113]+ in[112];
    assign chunk_pop[15] = in[127]+ in[126]+ in[125]+ in[124]+  in[123]+ in[122]+ in[121]+ in[120];
    assign chunk_pop[16] = in[135]+ in[134]+ in[133]+ in[132]+  in[131]+ in[130]+ in[129]+ in[128];
    assign chunk_pop[17] = in[143]+ in[142]+ in[141]+ in[140]+  in[139]+ in[138]+ in[137]+ in[136];
    assign chunk_pop[18] = in[151]+ in[150]+ in[149]+ in[148]+  in[147]+ in[146]+ in[145]+ in[144];
    assign chunk_pop[19] = in[159]+ in[158]+ in[157]+ in[156]+  in[155]+ in[154]+ in[153]+ in[152];
    assign chunk_pop[20] = in[167]+ in[166]+ in[165]+ in[164]+  in[163]+ in[162]+ in[161]+ in[160];
    assign chunk_pop[21] = in[175]+ in[174]+ in[173]+ in[172]+  in[171]+ in[170]+ in[169]+ in[168];
    assign chunk_pop[22] = in[183]+ in[182]+ in[181]+ in[180]+  in[179]+ in[178]+ in[177]+ in[176];
    assign chunk_pop[23] = in[191]+ in[190]+ in[189]+ in[188]+  in[187]+ in[186]+ in[185]+ in[184];
    assign chunk_pop[24] = in[199]+ in[198]+ in[197]+ in[196]+  in[195]+ in[194]+ in[193]+ in[192];
    assign chunk_pop[25] = in[207]+ in[206]+ in[205]+ in[204]+  in[203]+ in[202]+ in[201]+ in[200];
    assign chunk_pop[26] = in[215]+ in[214]+ in[213]+ in[212]+  in[211]+ in[210]+ in[209]+ in[208];
    assign chunk_pop[27] = in[223]+ in[222]+ in[221]+ in[220]+  in[219]+ in[218]+ in[217]+ in[216];
    assign chunk_pop[28] = in[231]+ in[230]+ in[229]+ in[228]+  in[227]+ in[226]+ in[225]+ in[224];
    assign chunk_pop[29] = in[239]+ in[238]+ in[237]+ in[236]+  in[235]+ in[234]+ in[233]+ in[232];
    assign chunk_pop[30] = in[247]+ in[246]+ in[245]+ in[244]+  in[243]+ in[242]+ in[241]+ in[240];
    // Chunk 31: last 7 bits only
    assign chunk_pop[31] = in[254] + in[253] + in[252] + in[251] + in[250] + in[249] + in[248];

    // Now sum all chunk_pop in balanced adder tree

    // Level 1: sum pairs (32 inputs, 16 outputs)
    wire [4:0] sum_l1 [15:0];
    assign sum_l1[ 0] = chunk_pop[ 0] + chunk_pop[ 1];
    assign sum_l1[ 1] = chunk_pop[ 2] + chunk_pop[ 3];
    assign sum_l1[ 2] = chunk_pop[ 4] + chunk_pop[ 5];
    assign sum_l1[ 3] = chunk_pop[ 6] + chunk_pop[ 7];
    assign sum_l1[ 4] = chunk_pop[ 8] + chunk_pop[ 9];
    assign sum_l1[ 5] = chunk_pop[10] + chunk_pop[11];
    assign sum_l1[ 6] = chunk_pop[12] + chunk_pop[13];
    assign sum_l1[ 7] = chunk_pop[14] + chunk_pop[15];
    assign sum_l1[ 8] = chunk_pop[16] + chunk_pop[17];
    assign sum_l1[ 9] = chunk_pop[18] + chunk_pop[19];
    assign sum_l1[10] = chunk_pop[20] + chunk_pop[21];
    assign sum_l1[11] = chunk_pop[22] + chunk_pop[23];
    assign sum_l1[12] = chunk_pop[24] + chunk_pop[25];
    assign sum_l1[13] = chunk_pop[26] + chunk_pop[27];
    assign sum_l1[14] = chunk_pop[28] + chunk_pop[29];
    assign sum_l1[15] = chunk_pop[30] + chunk_pop[31];

    // Level 2: 16 inputs -> 8 outputs
    wire [5:0] sum_l2 [7:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];
    assign sum_l2[2] = sum_l1[4] + sum_l1[5];
    assign sum_l2[3] = sum_l1[6] + sum_l1[7];
    assign sum_l2[4] = sum_l1[8] + sum_l1[9];
    assign sum_l2[5] = sum_l1[10] + sum_l1[11];
    assign sum_l2[6] = sum_l1[12] + sum_l1[13];
    assign sum_l2[7] = sum_l1[14] + sum_l1[15];

    // Level 3: 8 inputs -> 4 outputs
    wire [6:0] sum_l3 [3:0];
    assign sum_l3[0] = sum_l2[0] + sum_l2[1];
    assign sum_l3[1] = sum_l2[2] + sum_l2[3];
    assign sum_l3[2] = sum_l2[4] + sum_l2[5];
    assign sum_l3[3] = sum_l2[6] + sum_l2[7];

    // Level 4: 4 inputs -> 2 outputs
    wire [7:0] sum_l4 [1:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];

    // Level 5: 2 inputs -> 1 output (final sum)
    assign out = sum_l4[0] + sum_l4[1];
endmodule