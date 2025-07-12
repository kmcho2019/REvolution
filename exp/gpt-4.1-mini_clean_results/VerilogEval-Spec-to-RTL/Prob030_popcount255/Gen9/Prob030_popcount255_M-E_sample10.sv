module popcount3 (
    input  [2:0] in,
    output [1:0] out // max 3 ones fits in 2 bits
);
    // Sum bits explicitly (3 bits -> max 3)
    assign out = in[0] + in[1] + in[2];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: Split input into 85 groups of 3 bits (255/3=85 exactly)
    wire [1:0] pc3 [84:0];
    assign pc3[0]  = popcount3(in[2:0]);
    assign pc3[1]  = popcount3(in[5:3]);
    assign pc3[2]  = popcount3(in[8:6]);
    assign pc3[3]  = popcount3(in[11:9]);
    assign pc3[4]  = popcount3(in[14:12]);
    assign pc3[5]  = popcount3(in[17:15]);
    assign pc3[6]  = popcount3(in[20:18]);
    assign pc3[7]  = popcount3(in[23:21]);
    assign pc3[8]  = popcount3(in[26:24]);
    assign pc3[9]  = popcount3(in[29:27]);
    assign pc3[10] = popcount3(in[32:30]);
    assign pc3[11] = popcount3(in[35:33]);
    assign pc3[12] = popcount3(in[38:36]);
    assign pc3[13] = popcount3(in[41:39]);
    assign pc3[14] = popcount3(in[44:42]);
    assign pc3[15] = popcount3(in[47:45]);
    assign pc3[16] = popcount3(in[50:48]);
    assign pc3[17] = popcount3(in[53:51]);
    assign pc3[18] = popcount3(in[56:54]);
    assign pc3[19] = popcount3(in[59:57]);
    assign pc3[20] = popcount3(in[62:60]);
    assign pc3[21] = popcount3(in[65:63]);
    assign pc3[22] = popcount3(in[68:66]);
    assign pc3[23] = popcount3(in[71:69]);
    assign pc3[24] = popcount3(in[74:72]);
    assign pc3[25] = popcount3(in[77:75]);
    assign pc3[26] = popcount3(in[80:78]);
    assign pc3[27] = popcount3(in[83:81]);
    assign pc3[28] = popcount3(in[86:84]);
    assign pc3[29] = popcount3(in[89:87]);
    assign pc3[30] = popcount3(in[92:90]);
    assign pc3[31] = popcount3(in[95:93]);
    assign pc3[32] = popcount3(in[98:96]);
    assign pc3[33] = popcount3(in[101:99]);
    assign pc3[34] = popcount3(in[104:102]);
    assign pc3[35] = popcount3(in[107:105]);
    assign pc3[36] = popcount3(in[110:108]);
    assign pc3[37] = popcount3(in[113:111]);
    assign pc3[38] = popcount3(in[116:114]);
    assign pc3[39] = popcount3(in[119:117]);
    assign pc3[40] = popcount3(in[122:120]);
    assign pc3[41] = popcount3(in[125:123]);
    assign pc3[42] = popcount3(in[128:126]);
    assign pc3[43] = popcount3(in[131:129]);
    assign pc3[44] = popcount3(in[134:132]);
    assign pc3[45] = popcount3(in[137:135]);
    assign pc3[46] = popcount3(in[140:138]);
    assign pc3[47] = popcount3(in[143:141]);
    assign pc3[48] = popcount3(in[146:144]);
    assign pc3[49] = popcount3(in[149:147]);
    assign pc3[50] = popcount3(in[152:150]);
    assign pc3[51] = popcount3(in[155:153]);
    assign pc3[52] = popcount3(in[158:156]);
    assign pc3[53] = popcount3(in[161:159]);
    assign pc3[54] = popcount3(in[164:162]);
    assign pc3[55] = popcount3(in[167:165]);
    assign pc3[56] = popcount3(in[170:168]);
    assign pc3[57] = popcount3(in[173:171]);
    assign pc3[58] = popcount3(in[176:174]);
    assign pc3[59] = popcount3(in[179:177]);
    assign pc3[60] = popcount3(in[182:180]);
    assign pc3[61] = popcount3(in[185:183]);
    assign pc3[62] = popcount3(in[188:186]);
    assign pc3[63] = popcount3(in[191:189]);
    assign pc3[64] = popcount3(in[194:192]);
    assign pc3[65] = popcount3(in[197:195]);
    assign pc3[66] = popcount3(in[200:198]);
    assign pc3[67] = popcount3(in[203:201]);
    assign pc3[68] = popcount3(in[206:204]);
    assign pc3[69] = popcount3(in[209:207]);
    assign pc3[70] = popcount3(in[212:210]);
    assign pc3[71] = popcount3(in[215:213]);
    assign pc3[72] = popcount3(in[218:216]);
    assign pc3[73] = popcount3(in[221:219]);
    assign pc3[74] = popcount3(in[224:222]);
    assign pc3[75] = popcount3(in[227:225]);
    assign pc3[76] = popcount3(in[230:228]);
    assign pc3[77] = popcount3(in[233:231]);
    assign pc3[78] = popcount3(in[236:234]);
    assign pc3[79] = popcount3(in[239:237]);
    assign pc3[80] = popcount3(in[242:240]);
    assign pc3[81] = popcount3(in[245:243]);
    assign pc3[82] = popcount3(in[248:246]);
    assign pc3[83] = popcount3(in[251:249]);
    assign pc3[84] = popcount3(in[254:252]);

    // Step 2: sum groups of 4 pc3 outputs (each 2 bits) => 4 * max 3 = 12 max, fits in 4 bits
    // There are 85 pc3's, so 21 groups of 4 (84 inputs) plus 1 leftover
    wire [3:0] sum_l2 [20:0];
    // Sum 21 groups of four 2-bit values
    assign sum_l2[0]  = pc3[0]  + pc3[1]  + pc3[2]  + pc3[3];
    assign sum_l2[1]  = pc3[4]  + pc3[5]  + pc3[6]  + pc3[7];
    assign sum_l2[2]  = pc3[8]  + pc3[9]  + pc3[10] + pc3[11];
    assign sum_l2[3]  = pc3[12] + pc3[13] + pc3[14] + pc3[15];
    assign sum_l2[4]  = pc3[16] + pc3[17] + pc3[18] + pc3[19];
    assign sum_l2[5]  = pc3[20] + pc3[21] + pc3[22] + pc3[23];
    assign sum_l2[6]  = pc3[24] + pc3[25] + pc3[26] + pc3[27];
    assign sum_l2[7]  = pc3[28] + pc3[29] + pc3[30] + pc3[31];
    assign sum_l2[8]  = pc3[32] + pc3[33] + pc3[34] + pc3[35];
    assign sum_l2[9]  = pc3[36] + pc3[37] + pc3[38] + pc3[39];
    assign sum_l2[10] = pc3[40] + pc3[41] + pc3[42] + pc3[43];
    assign sum_l2[11] = pc3[44] + pc3[45] + pc3[46] + pc3[47];
    assign sum_l2[12] = pc3[48] + pc3[49] + pc3[50] + pc3[51];
    assign sum_l2[13] = pc3[52] + pc3[53] + pc3[54] + pc3[55];
    assign sum_l2[14] = pc3[56] + pc3[57] + pc3[58] + pc3[59];
    assign sum_l2[15] = pc3[60] + pc3[61] + pc3[62] + pc3[63];
    assign sum_l2[16] = pc3[64] + pc3[65] + pc3[66] + pc3[67];
    assign sum_l2[17] = pc3[68] + pc3[69] + pc3[70] + pc3[71];
    assign sum_l2[18] = pc3[72] + pc3[73] + pc3[74] + pc3[75];
    assign sum_l2[19] = pc3[76] + pc3[77] + pc3[78] + pc3[79];
    assign sum_l2[20] = pc3[80] + pc3[81] + pc3[82] + pc3[83];

    // Note pc3[84] left alone as leftover, add it at next stage (2 bits)

    // Step 3: Sum pairs of sum_l2 outputs (4-bit each)
    // 21 sum_l2 + leftover pc3[84], so sum_l2 has 21 elements (0..20), pairwise sums 10 pairs + one leftover
    wire [5:0] sum_l3 [9:0];
    assign sum_l3[0] = sum_l2[0]  + sum_l2[1];
    assign sum_l3[1] = sum_l2[2]  + sum_l2[3];
    assign sum_l3[2] = sum_l2[4]  + sum_l2[5];
    assign sum_l3[3] = sum_l2[6]  + sum_l2[7];
    assign sum_l3[4] = sum_l2[8]  + sum_l2[9];
    assign sum_l3[5] = sum_l2[10] + sum_l2[11];
    assign sum_l3[6] = sum_l2[12] + sum_l2[13];
    assign sum_l3[7] = sum_l2[14] + sum_l2[15];
    assign sum_l3[8] = sum_l2[16] + sum_l2[17];
    assign sum_l3[9] = sum_l2[18] + sum_l2[19];

    // Add sum_l2[20] (4 bits) plus pc3[84] (2 bits) in next stage

    // Step 4: Sum sum_l3 pairs (6 bits each), 10 elements -> 5 pairs
    wire [6:0] sum_l4 [4:0];
    assign sum_l4[0] = sum_l3[0] + sum_l3[1];
    assign sum_l4[1] = sum_l3[2] + sum_l3[3];
    assign sum_l4[2] = sum_l3[4] + sum_l3[5];
    assign sum_l4[3] = sum_l3[6] + sum_l3[7];
    assign sum_l4[4] = sum_l3[8] + sum_l3[9];

    // Step 5: Sum sum_l4 pairs (7 bits each), 5 elements -> 2 pairs + 1 leftover
    wire [7:0] sum_l5 [1:0];
    assign sum_l5[0] = sum_l4[0] + sum_l4[1];
    assign sum_l5[1] = sum_l4[2] + sum_l4[3];

    // leftover sum_l4[4], sum_l2[20], pc3[84]
    // sum_l4[4] is 7 bits, sum_l2[20] is 4 bits, pc3[84] is 2 bits
    // Add them all in next stage

    wire [8:0] leftover_sum; // up to 256 max, 9 bits enough
    assign leftover_sum = sum_l4[4] + sum_l2[20] + pc3[84];

    // Step 6: Final sum: sum_l5[0] + sum_l5[1] + leftover_sum
    // sum_l5 are 8 bits each, leftover_sum 9 bits, final sum max 255 fits in 8 bits

    wire [9:0] final_sum_wide;
    assign final_sum_wide = sum_l5[0] + sum_l5[1] + leftover_sum;

    // Output is 8 bits, final population count max 255 fits exactly
    assign out = final_sum_wide[7:0];

endmodule