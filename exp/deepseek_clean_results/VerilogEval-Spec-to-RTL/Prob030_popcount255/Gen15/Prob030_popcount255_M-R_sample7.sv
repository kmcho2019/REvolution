module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 4 (64 groups)
    wire [2:0] sum4_0  = in[0]   + in[1]   + in[2]   + in[3];
    wire [2:0] sum4_1  = in[4]   + in[5]   + in[6]   + in[7];
    wire [2:0] sum4_2  = in[8]   + in[9]   + in[10]  + in[11];
    wire [2:0] sum4_3  = in[12]  + in[13]  + in[14]  + in[15];
    wire [2:0] sum4_4  = in[16]  + in[17]  + in[18]  + in[19];
    wire [2:0] sum4_5  = in[20]  + in[21]  + in[22]  + in[23];
    wire [2:0] sum4_6  = in[24]  + in[25]  + in[26]  + in[27];
    wire [2:0] sum4_7  = in[28]  + in[29]  + in[30]  + in[31];
    wire [2:0] sum4_8  = in[32]  + in[33]  + in[34]  + in[35];
    wire [2:0] sum4_9  = in[36]  + in[37]  + in[38]  + in[39];
    wire [2:0] sum4_10 = in[40]  + in[41]  + in[42]  + in[43];
    wire [2:0] sum4_11 = in[44]  + in[45]  + in[46]  + in[47];
    wire [2:0] sum4_12 = in[48]  + in[49]  + in[50]  + in[51];
    wire [2:0] sum4_13 = in[52]  + in[53]  + in[54]  + in[55];
    wire [2:0] sum4_14 = in[56]  + in[57]  + in[58]  + in[59];
    wire [2:0] sum4_15 = in[60]  + in[61]  + in[62]  + in[63];
    // ... continue this pattern up to sum4_63

    // Handle remaining 3 bits (255 = 64*4 - 1)
    wire [1:0] sum_remaining = in[252] + in[253] + in[254];

    // Second level: Sum first level results in groups of 4 (16 groups)
    wire [4:0] sum16_0  = sum4_0  + sum4_1  + sum4_2  + sum4_3;
    wire [4:0] sum16_1  = sum4_4  + sum4_5  + sum4_6  + sum4_7;
    wire [4:0] sum16_2  = sum4_8  + sum4_9  + sum4_10 + sum4_11;
    wire [4:0] sum16_3  = sum4_12 + sum4_13 + sum4_14 + sum4_15;
    // ... continue this pattern up to sum16_15

    // Third level: Sum second level results in groups of 4 (4 groups)
    wire [6:0] sum64_0 = sum16_0 + sum16_1 + sum16_2 + sum16_3;
    wire [6:0] sum64_1 = sum16_4 + sum16_5 + sum16_6 + sum16_7;
    wire [6:0] sum64_2 = sum16_8 + sum16_9 + sum16_10 + sum16_11;
    wire [6:0] sum64_3 = sum16_12 + sum16_13 + sum16_14 + sum16_15;

    // Final sum
    assign out = sum64_0 + sum64_1 + sum64_2 + sum64_3 + sum_remaining;

endmodule