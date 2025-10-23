module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count 3-bit chunks (85 chunks)
    wire [1:0] sum1_00 = in[0] + in[1] + in[2];
    wire [1:0] sum1_01 = in[3] + in[4] + in[5];
    wire [1:0] sum1_02 = in[6] + in[7] + in[8];
    // ... (all 85 3-bit counters)
    wire [1:0] sum1_84 = in[252] + in[253] + in[254];

    // Level 2: Sum groups of 3 level1 counters (28 groups)
    wire [3:0] sum2_00 = sum1_00 + sum1_01 + sum1_02;
    wire [3:0] sum2_01 = sum1_03 + sum1_04 + sum1_05;
    // ... (28 groups)
    wire [3:0] sum2_28 = {2'b0, sum1_84};  // Last single counter

    // Level 3: Sum groups of 3 level2 counters (9 groups)
    wire [5:0] sum3_00 = sum2_00 + sum2_01 + sum2_02;
    wire [5:0] sum3_01 = sum2_03 + sum2_04 + sum2_05;
    // ... (9 groups)
    wire [5:0] sum3_09 = sum2_27 + sum2_28;  // Last group of 2

    // Level 4: Sum groups of 3 level3 counters (3 groups)
    wire [7:0] sum4_00 = sum3_00 + sum3_01 + sum3_02;
    wire [7:0] sum4_01 = sum3_03 + sum3_04 + sum3_05;
    wire [7:0] sum4_02 = sum3_06 + sum3_07 + sum3_08;
    wire [7:0] sum4_03 = sum3_09;  // Last single counter

    // Final sum
    assign out = sum4_00 + sum4_01 + sum4_02 + sum4_03;

endmodule