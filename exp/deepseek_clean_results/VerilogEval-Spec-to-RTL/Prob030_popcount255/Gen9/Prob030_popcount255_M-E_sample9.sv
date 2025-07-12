module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 0: Initial bit counts (each is 0 or 1)
    wire [254:0] stage0 = in;

    // Stage 1: Sum pairs of bits (1+1=2, needs 2 bits)
    wire [254:0] stage1;
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : STAGE1
            assign stage1[i*2+1:i*2] = stage0[i*2] + stage0[i*2+1];
        end
        // Handle last odd bit
        assign stage1[254] = stage0[254];
    endgenerate

    // Stage 2: Sum pairs of 2-bit numbers (max 4, needs 3 bits)
    wire [254:0] stage2;
    generate
        for (i = 0; i < 63; i = i + 1) begin : STAGE2
            assign stage2[i*4+2:i*4] = stage1[i*4+1:i*4] + stage1[i*4+3:i*4+2];
        end
        // Handle remaining 3 numbers (254/4 = 63 with remainder 2)
        assign stage2[254:252] = stage1[253:252] + stage1[255:254]; // Last two 2-bit numbers
    endgenerate

    // Stage 3: Sum pairs of 3-bit numbers (max 8, needs 4 bits)
    wire [254:0] stage3;
    generate
        for (i = 0; i < 31; i = i + 1) begin : STAGE3
            assign stage3[i*8+3:i*8] = stage2[i*8+3:i*8] + stage2[i*8+7:i*8+4];
        end
        // Handle remaining 7 numbers (254/8 = 31 with remainder 6)
        assign stage3[254:248] = stage2[251:248] + stage2[255:252]; // Last two 4-bit numbers
    endgenerate

    // Stage 4: Sum pairs of 4-bit numbers (max 16, needs 5 bits)
    wire [254:0] stage4;
    generate
        for (i = 0; i < 15; i = i + 1) begin : STAGE4
            assign stage4[i*16+4:i*16] = stage3[i*16+7:i*16] + stage3[i*16+15:i*16+8];
        end
        // Handle remaining 15 numbers (254/16 = 15 with remainder 14)
        assign stage4[254:240] = stage3[247:240] + stage3[255:248]; // Last two 8-bit numbers
    endgenerate

    // Final stage: Sum all remaining counts
    // We now have 16 numbers (15 of 5 bits, 1 of 4 bits)
    wire [7:0] sum1 = stage4[4:0] + stage4[9:5];
    wire [7:0] sum2 = stage4[14:10] + stage4[19:15];
    wire [7:0] sum3 = stage4[24:20] + stage4[29:25];
    wire [7:0] sum4 = stage4[34:30] + stage4[39:35];
    wire [7:0] sum5 = stage4[44:40] + stage4[49:45];
    wire [7:0] sum6 = stage4[54:50] + stage4[59:55];
    wire [7:0] sum7 = stage4[64:60] + stage4[69:65];
    wire [7:0] sum8 = stage4[74:70] + stage4[79:75];
    wire [7:0] sum9 = stage4[84:80] + stage4[89:85];
    wire [7:0] sum10 = stage4[94:90] + stage4[99:95];
    wire [7:0] sum11 = stage4[104:100] + stage4[109:105];
    wire [7:0] sum12 = stage4[114:110] + stage4[119:115];
    wire [7:0] sum13 = stage4[124:120] + stage4[129:125];
    wire [7:0] sum14 = stage4[134:130] + stage4[139:135];
    wire [7:0] sum15 = stage4[144:140] + stage4[149:145];
    wire [7:0] sum16 = stage4[154:150] + stage4[159:155];
    wire [7:0] sum17 = stage4[164:160] + stage4[169:165];
    wire [7:0] sum18 = stage4[174:170] + stage4[179:175];
    wire [7:0] sum19 = stage4[184:180] + stage4[189:185];
    wire [7:0] sum20 = stage4[194:190] + stage4[199:195];
    wire [7:0] sum21 = stage4[204:200] + stage4[209:205];
    wire [7:0] sum22 = stage4[214:210] + stage4[219:215];
    wire [7:0] sum23 = stage4[224:220] + stage4[229:225];
    wire [7:0] sum24 = stage4[234:230] + stage4[239:235];
    wire [7:0] sum25 = stage4[244:240] + stage4[249:245];
    wire [7:0] sum26 = stage4[254:250]; // Last partial sum

    assign out = sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7 + sum8 +
                 sum9 + sum10 + sum11 + sum12 + sum13 + sum14 + sum15 + sum16 +
                 sum17 + sum18 + sum19 + sum20 + sum21 + sum22 + sum23 + sum24 +
                 sum25 + sum26;

endmodule