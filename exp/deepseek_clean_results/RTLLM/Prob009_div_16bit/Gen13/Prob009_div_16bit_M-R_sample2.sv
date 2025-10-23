module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainder wires for each step
    wire [7:0] rem0, rem1, rem2, rem3, rem4, rem5, rem6, rem7;
    wire [7:0] rem8, rem9, rem10, rem11, rem12, rem13, rem14, rem15;

    // Step 0
    wire [8:0] step0 = {1'b0, A[15]};
    assign result[15] = (step0 >= {1'b0, B});
    assign rem0 = result[15] ? (step0 - B) : step0[7:0];

    // Step 1
    wire [8:0] step1 = {rem0, A[14]};
    assign result[14] = (step1 >= {1'b0, B});
    assign rem1 = result[14] ? (step1 - B) : step1[7:0];

    // Step 2
    wire [8:0] step2 = {rem1, A[13]};
    assign result[13] = (step2 >= {1'b0, B});
    assign rem2 = result[13] ? (step2 - B) : step2[7:0];

    // Step 3
    wire [8:0] step3 = {rem2, A[12]};
    assign result[12] = (step3 >= {1'b0, B});
    assign rem3 = result[12] ? (step3 - B) : step3[7:0];

    // Step 4
    wire [8:0] step4 = {rem3, A[11]};
    assign result[11] = (step4 >= {1'b0, B});
    assign rem4 = result[11] ? (step4 - B) : step4[7:0];

    // Step 5
    wire [8:0] step5 = {rem4, A[10]};
    assign result[10] = (step5 >= {1'b0, B});
    assign rem5 = result[10] ? (step5 - B) : step5[7:0];

    // Step 6
    wire [8:0] step6 = {rem5, A[9]};
    assign result[9] = (step6 >= {1'b0, B});
    assign rem6 = result[9] ? (step6 - B) : step6[7:0];

    // Step 7
    wire [8:0] step7 = {rem6, A[8]};
    assign result[8] = (step7 >= {1'b0, B});
    assign rem7 = result[8] ? (step7 - B) : step7[7:0];

    // Step 8
    wire [8:0] step8 = {rem7, A[7]};
    assign result[7] = (step8 >= {1'b0, B});
    assign rem8 = result[7] ? (step8 - B) : step8[7:0];

    // Step 9
    wire [8:0] step9 = {rem8, A[6]};
    assign result[6] = (step9 >= {1'b0, B});
    assign rem9 = result[6] ? (step9 - B) : step9[7:0];

    // Step 10
    wire [8:0] step10 = {rem9, A[5]};
    assign result[5] = (step10 >= {1'b0, B});
    assign rem10 = result[5] ? (step10 - B) : step10[7:0];

    // Step 11
    wire [8:0] step11 = {rem10, A[4]};
    assign result[4] = (step11 >= {1'b0, B});
    assign rem11 = result[4] ? (step11 - B) : step11[7:0];

    // Step 12
    wire [8:0] step12 = {rem11, A[3]};
    assign result[3] = (step12 >= {1'b0, B});
    assign rem12 = result[3] ? (step12 - B) : step12[7:0];

    // Step 13
    wire [8:0] step13 = {rem12, A[2]};
    assign result[2] = (step13 >= {1'b0, B});
    assign rem13 = result[2] ? (step13 - B) : step13[7:0];

    // Step 14
    wire [8:0] step14 = {rem13, A[1]};
    assign result[1] = (step14 >= {1'b0, B});
    assign rem14 = result[1] ? (step14 - B) : step14[7:0];

    // Step 15
    wire [8:0] step15 = {rem14, A[0]};
    assign result[0] = (step15 >= {1'b0, B});
    assign rem15 = result[0] ? (step15 - B) : step15[7:0];

    // Final remainder output
    assign odd = rem15;

endmodule