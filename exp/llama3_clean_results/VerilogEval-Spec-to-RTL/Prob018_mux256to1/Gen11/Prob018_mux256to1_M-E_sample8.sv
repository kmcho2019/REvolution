module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    wire [127:0] level1_0, level1_1;
    assign level1_0 = in[255:128];
    assign level1_1 = in[127:0];

    wire [63:0] level2_0, level2_1, level2_2, level2_3;
    assign level2_0 = level1_0[127:64];
    assign level2_1 = level1_0[63:0];
    assign level2_2 = level1_1[127:64];
    assign level2_3 = level1_1[63:0];

    wire [31:0] level3_0, level3_1, level3_2, level3_3, level3_4, level3_5, level3_6, level3_7;
    assign level3_0 = level2_0[63:32];
    assign level3_1 = level2_0[31:0];
    assign level3_2 = level2_1[63:32];
    assign level3_3 = level2_1[31:0];
    assign level3_4 = level2_2[63:32];
    assign level3_5 = level2_2[31:0];
    assign level3_6 = level2_3[63:32];
    assign level3_7 = level2_3[31:0];

    wire [15:0] level4_0, level4_1, level4_2, level4_3, level4_4, level4_5, level4_6, level4_7, 
                  level4_8, level4_9, level4_10, level4_11, level4_12, level4_13, level4_14, level4_15;
    assign level4_0 = level3_0[31:16];
    assign level4_1 = level3_0[15:0];
    assign level4_2 = level3_1[31:16];
    assign level4_3 = level3_1[15:0];
    assign level4_4 = level3_2[31:16];
    assign level4_5 = level3_2[15:0];
    assign level4_6 = level3_3[31:16];
    assign level4_7 = level3_3[15:0];
    assign level4_8 = level3_4[31:16];
    assign level4_9 = level3_4[15:0];
    assign level4_10 = level3_5[31:16];
    assign level4_11 = level3_5[15:0];
    assign level4_12 = level3_6[31:16];
    assign level4_13 = level3_6[15:0];
    assign level4_14 = level3_7[31:16];
    assign level4_15 = level3_7[15:0];

    wire [7:0] level5_0, level5_1, level5_2, level5_3, level5_4, level5_5, level5_6, level5_7, 
                  level5_8, level5_9, level5_10, level5_11, level5_12, level5_13, level5_14, level5_15, 
                  level5_16, level5_17, level5_18, level5_19, level5_20, level5_21, level5_22, level5_23, 
                  level5_24, level5_25, level5_26, level5_27, level5_28, level5_29, level5_30, level5_31;
    assign level5_0 = level4_0[15:8];
    assign level5_1 = level4_0[7:0];
    assign level5_2 = level4_1[15:8];
    assign level5_3 = level4_1[7:0];
    assign level5_4 = level4_2[15:8];
    assign level5_5 = level4_2[7:0];
    assign level5_6 = level4_3[15:8];
    assign level5_7 = level4_3[7:0];
    assign level5_8 = level4_4[15:8];
    assign level5_9 = level4_4[7:0];
    assign level5_10 = level4_5[15:8];
    assign level5_11 = level4_5[7:0];
    assign level5_12 = level4_6[15:8];
    assign level5_13 = level4_6[7:0];
    assign level5_14 = level4_7[15:8];
    assign level5_15 = level4_7[7:0];
    assign level5_16 = level4_8[15:8];
    assign level5_17 = level4_8[7:0];
    assign level5_18 = level4_9[15:8];
    assign level5_19 = level4_9[7:0];
    assign level5_20 = level4_10[15:8];
    assign level5_21 = level4_10[7:0];
    assign level5_22 = level4_11[15:8];
    assign level5_23 = level4_11[7:0];
    assign level5_24 = level4_12[15:8];
    assign level5_25 = level4_12[7:0];
    assign level5_26 = level4_13[15:8];
    assign level5_27 = level4_13[7:0];
    assign level5_28 = level4_14[15:8];
    assign level5_29 = level4_14[7:0];
    assign level5_30 = level4_15[15:8];
    assign level5_31 = level4_15[7:0];

    wire [3:0] level6_0, level6_1, level6_2, level6_3, level6_4, level6_5, level6_6, level6_7, 
                  level6_8, level6_9, level6_10, level6_11, level6_12, level6_13, level6_14, level6_15, 
                  level6_16, level6_17, level6_18, level6_19, level6_20, level6_21, level6_22, level6_23, 
                  level6_24, level6_25, level6_26, level6_27, level6_28, level6_29, level6_30, level6_31, 
                  level6_32, level6_33, level6_34, level6_35, level6_36, level6_37, level6_38, level6_39, 
                  level6_40, level6_41, level6_42, level6_43, level6_44, level6_45, level6_46, level6_47, 
                  level6_48, level6_49, level6_50, level6_51, level6_52, level6_53, level6_54, level6_55, 
                  level6_56, level6_57, level6_58, level6_59, level6_60, level6_61, level6_62, level6_63;
    assign level6_0 = level5_0[7:4];
    assign level6_1 = level5_0[3:0];
    assign level6_2 = level5_1[7:4];
    assign level6_3 = level5_1[3:0];
    assign level6_4 = level5_2[7:4];
    assign level6_5 = level5_2[3:0];
    assign level6_6 = level5_3[7:4];
    assign level6_7 = level5_3[3:0];
    assign level6_8 = level5_4[7:4];
    assign level6_9 = level5_4[3:0];
    assign level6_10 = level5_5[7:4];
    assign level6_11 = level5_5[3:0];
    assign level6_12 = level5_6[7:4];
    assign level6_13 = level5_6[3:0];
    assign level6_14 = level5_7[7:4];
    assign level6_15 = level5_7[3:0];
    assign level6_16 = level5_8[7:4];
    assign level6_17 = level5_8[3:0];
    assign level6_18 = level5_9[7:4];
    assign level6_19 = level5_9[3:0];
    assign level6_20 = level5_10[7:4];
    assign level6_21 = level5_10[3:0];
    assign level6_22 = level5_11[7:4];
    assign level6_23 = level5_11[3:0];
    assign level6_24 = level5_12[7:4];
    assign level6_25 = level5_12[3:0];
    assign level6_26 = level5_13[7:4];
    assign level6_27 = level5_13[3:0];
    assign level6_28 = level5_14[7:4];
    assign level6_29 = level5_14[3:0];
    assign level6_30 = level5_15[7:4];
    assign level6_31 = level5_15[3:0];
    assign level6_32 = level5_16[7:4];
    assign level6_33 = level5_16[3:0];
    assign level6_34 = level5_17[7:4];
    assign level6_35 = level5_17[3:0];
    assign level6_36 = level5_18[7:4];
    assign level6_37 = level5_18[3:0];
    assign level6_38 = level5_19[7:4];
    assign level6_39 = level5_19[3:0];
    assign level6_40 = level5_20[7:4];
    assign level6_41 = level5_20[3:0];
    assign level6_42 = level5_21[7:4];
    assign level6_43 = level5_21[3:0];
    assign level6_44 = level5_22[7:4];
    assign level6_45 = level5_22[3:0];
    assign level6_46 = level5_23[7:4];
    assign level6_47 = level5_23[3:0];
    assign level6_48 = level5_24[7:4];
    assign level6_49 = level5_24[3:0];
    assign level6_50 = level5_25[7:4];
    assign level6_51 = level5_25[3:0];
    assign level6_52 = level5_26[7:4];
    assign level6_53 = level5_26[3:0];
    assign level6_54 = level5_27[7:4];
    assign level6_55 = level5_27[3:0];
    assign level6_56 = level5_28[7:4];
    assign level6_57 = level5_28[3:0];
    assign level6_58 = level5_29[7:4];
    assign level6_59 = level5_29[3:0];
    assign level6_60 = level5_30[7:4];
    assign level6_61 = level5_30[3:0];
    assign level6_62 = level5_31[7:4];
    assign level6_63 = level5_31[3:0];

    assign out = level6_0[sel[7:4]][sel[3:0]];

endmodule