module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Step 15
    wire [8:0] step15 = {1'b0, A[15]};
    wire step15_ge = (step15 >= {1'b0, B});
    wire [7:0] rem15 = step15_ge ? (step15 - B) : step15[7:0];
    wire bit15 = step15_ge;

    // Step 14
    wire [8:0] step14 = {rem15, A[14]};
    wire step14_ge = (step14 >= {1'b0, B});
    wire [7:0] rem14 = step14_ge ? (step14 - B) : step14[7:0];
    wire bit14 = step14_ge;

    // Step 13
    wire [8:0] step13 = {rem14, A[13]};
    wire step13_ge = (step13 >= {1'b0, B});
    wire [7:0] rem13 = step13_ge ? (step13 - B) : step13[7:0];
    wire bit13 = step13_ge;

    // Step 12
    wire [8:0] step12 = {rem13, A[12]};
    wire step12_ge = (step12 >= {1'b0, B});
    wire [7:0] rem12 = step12_ge ? (step12 - B) : step12[7:0];
    wire bit12 = step12_ge;

    // Step 11
    wire [8:0] step11 = {rem12, A[11]};
    wire step11_ge = (step11 >= {1'b0, B});
    wire [7:0] rem11 = step11_ge ? (step11 - B) : step11[7:0];
    wire bit11 = step11_ge;

    // Step 10
    wire [8:0] step10 = {rem11, A[10]};
    wire step10_ge = (step10 >= {1'b0, B});
    wire [7:0] rem10 = step10_ge ? (step10 - B) : step10[7:0];
    wire bit10 = step10_ge;

    // Step 9
    wire [8:0] step9 = {rem10, A[9]};
    wire step9_ge = (step9 >= {1'b0, B});
    wire [7:0] rem9 = step9_ge ? (step9 - B) : step9[7:0];
    wire bit9 = step9_ge;

    // Step 8
    wire [8:0] step8 = {rem9, A[8]};
    wire step8_ge = (step8 >= {1'b0, B});
    wire [7:0] rem8 = step8_ge ? (step8 - B) : step8[7:0];
    wire bit8 = step8_ge;

    // Step 7
    wire [8:0] step7 = {rem8, A[7]};
    wire step7_ge = (step7 >= {1'b0, B});
    wire [7:0] rem7 = step7_ge ? (step7 - B) : step7[7:0];
    wire bit7 = step7_ge;

    // Step 6
    wire [8:0] step6 = {rem7, A[6]};
    wire step6_ge = (step6 >= {1'b0, B});
    wire [7:0] rem6 = step6_ge ? (step6 - B) : step6[7:0];
    wire bit6 = step6_ge;

    // Step 5
    wire [8:0] step5 = {rem6, A[5]};
    wire step5_ge = (step5 >= {1'b0, B});
    wire [7:0] rem5 = step5_ge ? (step5 - B) : step5[7:0];
    wire bit5 = step5_ge;

    // Step 4
    wire [8:0] step4 = {rem5, A[4]};
    wire step4_ge = (step4 >= {1'b0, B});
    wire [7:0] rem4 = step4_ge ? (step4 - B) : step4[7:0];
    wire bit4 = step4_ge;

    // Step 3
    wire [8:0] step3 = {rem4, A[3]};
    wire step3_ge = (step3 >= {1'b0, B});
    wire [7:0] rem3 = step3_ge ? (step3 - B) : step3[7:0];
    wire bit3 = step3_ge;

    // Step 2
    wire [8:0] step2 = {rem3, A[2]};
    wire step2_ge = (step2 >= {1'b0, B});
    wire [7:0] rem2 = step2_ge ? (step2 - B) : step2[7:0];
    wire bit2 = step2_ge;

    // Step 1
    wire [8:0] step1 = {rem2, A[1]};
    wire step1_ge = (step1 >= {1'b0, B});
    wire [7:0] rem1 = step1_ge ? (step1 - B) : step1[7:0];
    wire bit1 = step1_ge;

    // Step 0
    wire [8:0] step0 = {rem1, A[0]};
    wire step0_ge = (step0 >= {1'b0, B});
    wire [7:0] rem0 = step0_ge ? (step0 - B) : step0[7:0];
    wire bit0 = step0_ge;

    // Output assignments
    assign result = {bit15, bit14, bit13, bit12, bit11, bit10, bit9, bit8,
                    bit7, bit6, bit5, bit4, bit3, bit2, bit1, bit0};
    assign odd = rem0;

endmodule