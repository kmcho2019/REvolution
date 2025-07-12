module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] l1_00, l1_01, l1_02, l1_03, l1_04, l1_05, l1_06, l1_07, l1_08, l1_09;
    wire [1:0] l1_10, l1_11, l1_12, l1_13, l1_14, l1_15, l1_16, l1_17, l1_18, l1_19;
    wire [1:0] l1_20, l1_21, l1_22, l1_23, l1_24, l1_25, l1_26, l1_27, l1_28, l1_29;
    wire [1:0] l1_30, l1_31, l1_32, l1_33, l1_34, l1_35, l1_36, l1_37, l1_38, l1_39;
    wire [1:0] l1_40, l1_41, l1_42, l1_43, l1_44, l1_45, l1_46, l1_47, l1_48, l1_49;
    wire [1:0] l1_50, l1_51, l1_52, l1_53, l1_54, l1_55, l1_56, l1_57, l1_58, l1_59;
    wire [1:0] l1_60, l1_61, l1_62, l1_63, l1_64, l1_65, l1_66, l1_67, l1_68, l1_69;
    wire [1:0] l1_70, l1_71, l1_72, l1_73, l1_74, l1_75, l1_76, l1_77, l1_78, l1_79;
    wire [1:0] l1_80, l1_81, l1_82, l1_83, l1_84;

    assign l1_00 = in[0] + in[1] + in[2];
    assign l1_01 = in[3] + in[4] + in[5];
    // ... (all 85 level 1 assignments)
    assign l1_84 = in[252] + in[253] + in[254];

    // Level 2: Sum 3 level1 counters (28 groups of 3, 1 group of 1)
    wire [3:0] l2_00, l2_01, l2_02, l2_03, l2_04, l2_05, l2_06, l2_07, l2_08, l2_09;
    wire [3:0] l2_10, l2_11, l2_12, l2_13, l2_14, l2_15, l2_16, l2_17, l2_18, l2_19;
    wire [3:0] l2_20, l2_21, l2_22, l2_23, l2_24, l2_25, l2_26, l2_27, l2_28;

    assign l2_00 = l1_00 + l1_01 + l1_02;
    assign l2_01 = l1_03 + l1_04 + l1_05;
    // ... (all 28 level 2 assignments)
    assign l2_28 = {2'b0, l1_84};  // Zero extend last counter

    // Level 3: Sum 3 level2 counters (9 groups of 3, 1 group of 2)
    wire [5:0] l3_00, l3_01, l3_02, l3_03, l3_04, l3_05, l3_06, l3_07, l3_08, l3_09;

    assign l3_00 = l2_00 + l2_01 + l2_02;
    assign l3_01 = l2_03 + l2_04 + l2_05;
    // ... (all 9 level 3 assignments)
    assign l3_09 = l2_27 + l2_28;

    // Level 4: Sum 3 level3 counters (3 groups of 3, 1 group of 1)
    wire [7:0] l4_00, l4_01, l4_02, l4_03;

    assign l4_00 = l3_00 + l3_01 + l3_02;
    assign l4_01 = l3_03 + l3_04 + l3_05;
    assign l4_02 = l3_06 + l3_07 + l3_08;
    assign l4_03 = l3_09;

    // Final level: Sum all level4 counters using consistent ternary pattern
    assign out = (l4_00 + l4_01) + (l4_02 + l4_03);

endmodule