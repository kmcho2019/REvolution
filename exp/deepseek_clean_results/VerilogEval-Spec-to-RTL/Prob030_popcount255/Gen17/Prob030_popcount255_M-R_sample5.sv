module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First stage: Sum all bits in groups of 3
    wire [6:0] sum3_0  = in[2:0]   + in[5:3]   + in[8:6]   + in[11:9];
    wire [6:0] sum3_1  = in[14:12] + in[17:15] + in[20:18] + in[23:21];
    wire [6:0] sum3_2  = in[26:24] + in[29:27] + in[32:30] + in[35:33];
    wire [6:0] sum3_3  = in[38:36] + in[41:39] + in[44:42] + in[47:45];
    wire [6:0] sum3_4  = in[50:48] + in[53:51] + in[56:54] + in[59:57];
    wire [6:0] sum3_5  = in[62:60] + in[65:63] + in[68:66] + in[71:69];
    wire [6:0] sum3_6  = in[74:72] + in[77:75] + in[80:78] + in[83:81];
    wire [6:0] sum3_7  = in[86:84] + in[89:87] + in[92:90] + in[95:93];
    wire [6:0] sum3_8  = in[98:96] + in[101:99] + in[104:102] + in[107:105];
    wire [6:0] sum3_9  = in[110:108] + in[113:111] + in[116:114] + in[119:117];
    wire [6:0] sum3_10 = in[122:120] + in[125:123] + in[128:126] + in[131:129];
    wire [6:0] sum3_11 = in[134:132] + in[137:135] + in[140:138] + in[143:141];
    wire [6:0] sum3_12 = in[146:144] + in[149:147] + in[152:150] + in[155:153];
    wire [6:0] sum3_13 = in[158:156] + in[161:159] + in[164:162] + in[167:165];
    wire [6:0] sum3_14 = in[170:168] + in[173:171] + in[176:174] + in[179:177];
    wire [6:0] sum3_15 = in[182:180] + in[185:183] + in[188:186] + in[191:189];
    wire [6:0] sum3_16 = in[194:192] + in[197:195] + in[200:198] + in[203:201];
    wire [6:0] sum3_17 = in[206:204] + in[209:207] + in[212:210] + in[215:213];
    wire [6:0] sum3_18 = in[218:216] + in[221:219] + in[224:222] + in[227:225];
    wire [6:0] sum3_19 = in[230:228] + in[233:231] + in[236:234] + in[239:237];
    wire [6:0] sum3_20 = in[242:240] + in[245:243] + in[248:246] + in[251:249];
    wire [6:0] sum3_21 = in[254:252];

    // Second stage: Sum groups of 4 partial sums
    wire [8:0] sum4_0 = sum3_0 + sum3_1 + sum3_2 + sum3_3;
    wire [8:0] sum4_1 = sum3_4 + sum3_5 + sum3_6 + sum3_7;
    wire [8:0] sum4_2 = sum3_8 + sum3_9 + sum3_10 + sum3_11;
    wire [8:0] sum4_3 = sum3_12 + sum3_13 + sum3_14 + sum3_15;
    wire [8:0] sum4_4 = sum3_16 + sum3_17 + sum3_18 + sum3_19;
    wire [8:0] sum4_5 = sum3_20 + sum3_21;

    // Final stage: Balanced binary tree summation
    wire [8:0] sum_stage1 = sum4_0 + sum4_1 + sum4_2;
    wire [8:0] sum_stage2 = sum4_3 + sum4_4 + sum4_5;
    assign out = sum_stage1 + sum_stage2;

endmodule