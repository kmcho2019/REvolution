module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Internal signals
    wire [8:0] step0, step1, step2, step3, step4, step5, step6, step7;
    wire [8:0] step8, step9, step10, step11, step12, step13, step14, step15;
    wire [7:0] final_remainder;

    // Division steps
    assign step0 = {1'b0, A[15]};
    assign result[15] = (step0 >= {1'b0, B});
    assign step1 = { (step0 >= {1'b0, B}) ? (step0 - B) : step0[7:0], A[14] };
    assign result[14] = (step1 >= {1'b0, B});
    assign step2 = { (step1 >= {1'b0, B}) ? (step1 - B) : step1[7:0], A[13] };
    assign result[13] = (step2 >= {1'b0, B});
    assign step3 = { (step2 >= {1'b0, B}) ? (step2 - B) : step2[7:0], A[12] };
    assign result[12] = (step3 >= {1'b0, B});
    assign step4 = { (step3 >= {1'b0, B}) ? (step3 - B) : step3[7:0], A[11] };
    assign result[11] = (step4 >= {1'b0, B});
    assign step5 = { (step4 >= {1'b0, B}) ? (step4 - B) : step4[7:0], A[10] };
    assign result[10] = (step5 >= {1'b0, B});
    assign step6 = { (step5 >= {1'b0, B}) ? (step5 - B) : step5[7:0], A[9] };
    assign result[9] = (step6 >= {1'b0, B});
    assign step7 = { (step6 >= {1'b0, B}) ? (step6 - B) : step6[7:0], A[8] };
    assign result[8] = (step7 >= {1'b0, B});
    assign step8 = { (step7 >= {1'b0, B}) ? (step7 - B) : step7[7:0], A[7] };
    assign result[7] = (step8 >= {1'b0, B});
    assign step9 = { (step8 >= {1'b0, B}) ? (step8 - B) : step8[7:0], A[6] };
    assign result[6] = (step9 >= {1'b0, B});
    assign step10 = { (step9 >= {1'b0, B}) ? (step9 - B) : step9[7:0], A[5] };
    assign result[5] = (step10 >= {1'b0, B});
    assign step11 = { (step10 >= {1'b0, B}) ? (step10 - B) : step10[7:0], A[4] };
    assign result[4] = (step11 >= {1'b0, B});
    assign step12 = { (step11 >= {1'b0, B}) ? (step11 - B) : step11[7:0], A[3] };
    assign result[3] = (step12 >= {1'b0, B});
    assign step13 = { (step12 >= {1'b0, B}) ? (step12 - B) : step12[7:0], A[2] };
    assign result[2] = (step13 >= {1'b0, B});
    assign step14 = { (step13 >= {1'b0, B}) ? (step13 - B) : step13[7:0], A[1] };
    assign result[1] = (step14 >= {1'b0, B});
    assign step15 = { (step14 >= {1'b0, B}) ? (step14 - B) : step14[7:0], A[0] };
    assign result[0] = (step15 >= {1'b0, B});

    // Final remainder calculation
    assign final_remainder = (step15 >= {1'b0, B}) ? (step15 - B) : step15[7:0];
    assign odd = {8'b0, final_remainder};

endmodule