module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Level 1: Divide the input into 25 segments of 4 bits each
    wire [3:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9, seg10,
          seg11, seg12, seg13, seg14, seg15, seg16, seg17, seg18, seg19, seg20,
          seg21, seg22, seg23, seg24, seg25;

    assign seg1 = in[3:0];
    assign seg2 = in[7:4];
    assign seg3 = in[11:8];
    assign seg4 = in[15:12];
    assign seg5 = in[19:16];
    assign seg6 = in[23:20];
    assign seg7 = in[27:24];
    assign seg8 = in[31:28];
    assign seg9 = in[35:32];
    assign seg10 = in[39:36];
    assign seg11 = in[43:40];
    assign seg12 = in[47:44];
    assign seg13 = in[51:48];
    assign seg14 = in[55:52];
    assign seg15 = in[59:56];
    assign seg16 = in[63:60];
    assign seg17 = in[67:64];
    assign seg18 = in[71:68];
    assign seg19 = in[75:72];
    assign seg20 = in[79:76];
    assign seg21 = in[83:80];
    assign seg22 = in[87:84];
    assign seg23 = in[91:88];
    assign seg24 = in[95:92];
    assign seg25 = in[99:96];

    // Level 2: Perform AND, OR, and XOR operations on each segment
    wire and_seg1, or_seg1, xor_seg1;
    wire and_seg2, or_seg2, xor_seg2;
    wire and_seg3, or_seg3, xor_seg3;
    wire and_seg4, or_seg4, xor_seg4;
    wire and_seg5, or_seg5, xor_seg5;
    wire and_seg6, or_seg6, xor_seg6;
    wire and_seg7, or_seg7, xor_seg7;
    wire and_seg8, or_seg8, xor_seg8;
    wire and_seg9, or_seg9, xor_seg9;
    wire and_seg10, or_seg10, xor_seg10;
    wire and_seg11, or_seg11, xor_seg11;
    wire and_seg12, or_seg12, xor_seg12;
    wire and_seg13, or_seg13, xor_seg13;
    wire and_seg14, or_seg14, xor_seg14;
    wire and_seg15, or_seg15, xor_seg15;
    wire and_seg16, or_seg16, xor_seg16;
    wire and_seg17, or_seg17, xor_seg17;
    wire and_seg18, or_seg18, xor_seg18;
    wire and_seg19, or_seg19, xor_seg19;
    wire and_seg20, or_seg20, xor_seg20;
    wire and_seg21, or_seg21, xor_seg21;
    wire and_seg22, or_seg22, xor_seg22;
    wire and_seg23, or_seg23, xor_seg23;
    wire and_seg24, or_seg24, xor_seg24;
    wire and_seg25, or_seg25, xor_seg25;

    assign and_seg1 = (seg1[0] & seg1[1] & seg1[2] & seg1[3]);
    assign or_seg1 = (seg1[0] | seg1[1] | seg1[2] | seg1[3]);
    assign xor_seg1 = (seg1[0] ^ seg1[1] ^ seg1[2] ^ seg1[3]);

    assign and_seg2 = (seg2[0] & seg2[1] & seg2[2] & seg2[3]);
    assign or_seg2 = (seg2[0] | seg2[1] | seg2[2] | seg2[3]);
    assign xor_seg2 = (seg2[0] ^ seg2[1] ^ seg2[2] ^ seg2[3]);

    assign and_seg3 = (seg3[0] & seg3[1] & seg3[2] & seg3[3]);
    assign or_seg3 = (seg3[0] | seg3[1] | seg3[2] | seg3[3]);
    assign xor_seg3 = (seg3[0] ^ seg3[1] ^ seg3[2] ^ seg3[3]);

    assign and_seg4 = (seg4[0] & seg4[1] & seg4[2] & seg4[3]);
    assign or_seg4 = (seg4[0] | seg4[1] | seg4[2] | seg4[3]);
    assign xor_seg4 = (seg4[0] ^ seg4[1] ^ seg4[2] ^ seg4[3]);

    assign and_seg5 = (seg5[0] & seg5[1] & seg5[2] & seg5[3]);
    assign or_seg5 = (seg5[0] | seg5[1] | seg5[2] | seg5[3]);
    assign xor_seg5 = (seg5[0] ^ seg5[1] ^ seg5[2] ^ seg5[3]);

    assign and_seg6 = (seg6[0] & seg6[1] & seg6[2] & seg6[3]);
    assign or_seg6 = (seg6[0] | seg6[1] | seg6[2] | seg6[3]);
    assign xor_seg6 = (seg6[0] ^ seg6[1] ^ seg6[2] ^ seg6[3]);

    assign and_seg7 = (seg7[0] & seg7[1] & seg7[2] & seg7[3]);
    assign or_seg7 = (seg7[0] | seg7[1] | seg7[2] | seg7[3]);
    assign xor_seg7 = (seg7[0] ^ seg7[1] ^ seg7[2] ^ seg7[3]);

    assign and_seg8 = (seg8[0] & seg8[1] & seg8[2] & seg8[3]);
    assign or_seg8 = (seg8[0] | seg8[1] | seg8[2] | seg8[3]);
    assign xor_seg8 = (seg8[0] ^ seg8[1] ^ seg8[2] ^ seg8[3]);

    assign and_seg9 = (seg9[0] & seg9[1] & seg9[2] & seg9[3]);
    assign or_seg9 = (seg9[0] | seg9[1] | seg9[2] | seg9[3]);
    assign xor_seg9 = (seg9[0] ^ seg9[1] ^ seg9[2] ^ seg9[3]);

    assign and_seg10 = (seg10[0] & seg10[1] & seg10[2] & seg10[3]);
    assign or_seg10 = (seg10[0] | seg10[1] | seg10[2] | seg10[3]);
    assign xor_seg10 = (seg10[0] ^ seg10[1] ^ seg10[2] ^ seg10[3]);

    assign and_seg11 = (seg11[0] & seg11[1] & seg11[2] & seg11[3]);
    assign or_seg11 = (seg11[0] | seg11[1] | seg11[2] | seg11[3]);
    assign xor_seg11 = (seg11[0] ^ seg11[1] ^ seg11[2] ^ seg11[3]);

    assign and_seg12 = (seg12[0] & seg12[1] & seg12[2] & seg12[3]);
    assign or_seg12 = (seg12[0] | seg12[1] | seg12[2] | seg12[3]);
    assign xor_seg12 = (seg12[0] ^ seg12[1] ^ seg12[2] ^ seg12[3]);

    assign and_seg13 = (seg13[0] & seg13[1] & seg13[2] & seg13[3]);
    assign or_seg13 = (seg13[0] | seg13[1] | seg13[2] | seg13[3]);
    assign xor_seg13 = (seg13[0] ^ seg13[1] ^ seg13[2] ^ seg13[3]);

    assign and_seg14 = (seg14[0] & seg14[1] & seg14[2] & seg14[3]);
    assign or_seg14 = (seg14[0] | seg14[1] | seg14[2] | seg14[3]);
    assign xor_seg14 = (seg14[0] ^ seg14[1] ^ seg14[2] ^ seg14[3]);

    assign and_seg15 = (seg15[0] & seg15[1] & seg15[2] & seg15[3]);
    assign or_seg15 = (seg15[0] | seg15[1] | seg15[2] | seg15[3]);
    assign xor_seg15 = (seg15[0] ^ seg15[1] ^ seg15[2] ^ seg15[3]);

    assign and_seg16 = (seg16[0] & seg16[1] & seg16[2] & seg16[3]);
    assign or_seg16 = (seg16[0] | seg16[1] | seg16[2] | seg16[3]);
    assign xor_seg16 = (seg16[0] ^ seg16[1] ^ seg16[2] ^ seg16[3]);

    assign and_seg17 = (seg17[0] & seg17[1] & seg17[2] & seg17[3]);
    assign or_seg17 = (seg17[0] | seg17[1] | seg17[2] | seg17[3]);
    assign xor_seg17 = (seg17[0] ^ seg17[1] ^ seg17[2] ^ seg17[3]);

    assign and_seg18 = (seg18[0] & seg18[1] & seg18[2] & seg18[3]);
    assign or_seg18 = (seg18[0] | seg18[1] | seg18[2] | seg18[3]);
    assign xor_seg18 = (seg18[0] ^ seg18[1] ^ seg18[2] ^ seg18[3]);

    assign and_seg19 = (seg19[0] & seg19[1] & seg19[2] & seg19[3]);
    assign or_seg19 = (seg19[0] | seg19[1] | seg19[2] | seg19[3]);
    assign xor_seg19 = (seg19[0] ^ seg19[1] ^ seg19[2] ^ seg19[3]);

    assign and_seg20 = (seg20[0] & seg20[1] & seg20[2] & seg20[3]);
    assign or_seg20 = (seg20[0] | seg20[1] | seg20[2] | seg20[3]);
    assign xor_seg20 = (seg20[0] ^ seg20[1] ^ seg20[2] ^ seg20[3]);

    assign and_seg21 = (seg21[0] & seg21[1] & seg21[2] & seg21[3]);
    assign or_seg21 = (seg21[0] | seg21[1] | seg21[2] | seg21[3]);
    assign xor_seg21 = (seg21[0] ^ seg21[1] ^ seg21[2] ^ seg21[3]);

    assign and_seg22 = (seg22[0] & seg22[1] & seg22[2] & seg22[3]);
    assign or_seg22 = (seg22[0] | seg22[1] | seg22[2] | seg22[3]);
    assign xor_seg22 = (seg22[0] ^ seg22[1] ^ seg22[2] ^ seg22[3]);

    assign and_seg23 = (seg23[0] & seg23[1] & seg23[2] & seg23[3]);
    assign or_seg23 = (seg23[0] | seg23[1] | seg23[2] | seg23[3]);
    assign xor_seg23 = (seg23[0] ^ seg23[1] ^ seg23[2] ^ seg23[3]);

    assign and_seg24 = (seg24[0] & seg24[1] & seg24[2] & seg24[3]);
    assign or_seg24 = (seg24[0] | seg24[1] | seg24[2] | seg24[3]);
    assign xor_seg24 = (seg24[0] ^ seg24[1] ^ seg24[2] ^ seg24[3]);

    assign and_seg25 = (seg25[0] & seg25[1] & seg25[2] & seg25[3]);
    assign or_seg25 = (seg25[0] | seg25[1] | seg25[2] | seg25[3]);
    assign xor_seg25 = (seg25[0] ^ seg25[1] ^ seg25[2] ^ seg25[3]);

    // Level 3: Combine the results from each segment
    wire and_level2_1, or_level2_1, xor_level2_1;
    wire and_level2_2, or_level2_2, xor_level2_2;
    wire and_level2_3, or_level2_3, xor_level2_3;
    wire and_level2_4, or_level2_4, xor_level2_4;
    wire and_level2_5, or_level2_5, xor_level2_5;

    assign and_level2_1 = (and_seg1 & and_seg2 & and_seg3 & and_seg4 & and_seg5);
    assign or_level2_1 = (or_seg1 | or_seg2 | or_seg3 | or_seg4 | or_seg5);
    assign xor_level2_1 = (xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4 ^ xor_seg5);

    assign and_level2_2 = (and_seg6 & and_seg7 & and_seg8 & and_seg9 & and_seg10);
    assign or_level2_2 = (or_seg6 | or_seg7 | or_seg8 | or_seg9 | or_seg10);
    assign xor_level2_2 = (xor_seg6 ^ xor_seg7 ^ xor_seg8 ^ xor_seg9 ^ xor_seg10);

    assign and_level2_3 = (and_seg11 & and_seg12 & and_seg13 & and_seg14 & and_seg15);
    assign or_level2_3 = (or_seg11 | or_seg12 | or_seg13 | or_seg14 | or_seg15);
    assign xor_level2_3 = (xor_seg11 ^ xor_seg12 ^ xor_seg13 ^ xor_seg14 ^ xor_seg15);

    assign and_level2_4 = (and_seg16 & and_seg17 & and_seg18 & and_seg19 & and_seg20);
    assign or_level2_4 = (or_seg16 | or_seg17 | or_seg18 | or_seg19 | or_seg20);
    assign xor_level2_4 = (xor_seg16 ^ xor_seg17 ^ xor_seg18 ^ xor_seg19 ^ xor_seg20);

    assign and_level2_5 = (and_seg21 & and_seg22 & and_seg23 & and_seg24 & and_seg25);
    assign or_level2_5 = (or_seg21 | or_seg22 | or_seg23 | or_seg24 | or_seg25);
    assign xor_level2_5 = (xor_seg21 ^ xor_seg22 ^ xor_seg23 ^ xor_seg24 ^ xor_seg25);

    // Level 4: Combine the results from each level
    wire and_level3, or_level3, xor_level3;

    assign and_level3 = (and_level2_1 & and_level2_2 & and_level2_3 & and_level2_4 & and_level2_5);
    assign or_level3 = (or_level2_1 | or_level2_2 | or_level2_3 | or_level2_4 | or_level2_5);
    assign xor_level3 = (xor_level2_1 ^ xor_level2_2 ^ xor_level2_3 ^ xor_level2_4 ^ xor_level2_5);

    // Final outputs
    assign out_and = and_level3;
    assign out_or = or_level3;
    assign out_xor = xor_level3;

endmodule