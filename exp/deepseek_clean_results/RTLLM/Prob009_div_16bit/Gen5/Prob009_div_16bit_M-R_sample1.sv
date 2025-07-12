module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for each division step
    wire [8:0] step0, step1, step2, step3, step4, step5, step6, step7;
    wire [8:0] step8, step9, step10, step11, step12, step13, step14, step15;
    
    wire [7:0] rem0, rem1, rem2, rem3, rem4, rem5, rem6, rem7;
    wire [7:0] rem8, rem9, rem10, rem11, rem12, rem13, rem14, rem15;
    
    // Initialize first step
    assign step0 = {1'b0, A[15]};
    assign rem0 = (step0 >= {1'b0, B}) ? (step0 - B) : step0[7:0];
    assign result[15] = (step0 >= {1'b0, B});
    
    // Subsequent steps
    assign step1 = {rem0, A[14]};
    assign rem1 = (step1 >= {1'b0, B}) ? (step1 - B) : step1[7:0];
    assign result[14] = (step1 >= {1'b0, B});
    
    assign step2 = {rem1, A[13]};
    assign rem2 = (step2 >= {1'b0, B}) ? (step2 - B) : step2[7:0];
    assign result[13] = (step2 >= {1'b0, B});
    
    assign step3 = {rem2, A[12]};
    assign rem3 = (step3 >= {1'b0, B}) ? (step3 - B) : step3[7:0];
    assign result[12] = (step3 >= {1'b0, B});
    
    assign step4 = {rem3, A[11]};
    assign rem4 = (step4 >= {1'b0, B}) ? (step4 - B) : step4[7:0];
    assign result[11] = (step4 >= {1'b0, B});
    
    assign step5 = {rem4, A[10]};
    assign rem5 = (step5 >= {1'b0, B}) ? (step5 - B) : step5[7:0];
    assign result[10] = (step5 >= {1'b0, B});
    
    assign step6 = {rem5, A[9]};
    assign rem6 = (step6 >= {1'b0, B}) ? (step6 - B) : step6[7:0];
    assign result[9] = (step6 >= {1'b0, B});
    
    assign step7 = {rem6, A[8]};
    assign rem7 = (step7 >= {1'b0, B}) ? (step7 - B) : step7[7:0];
    assign result[8] = (step7 >= {1'b0, B});
    
    assign step8 = {rem7, A[7]};
    assign rem8 = (step8 >= {1'b0, B}) ? (step8 - B) : step8[7:0];
    assign result[7] = (step8 >= {1'b0, B});
    
    assign step9 = {rem8, A[6]};
    assign rem9 = (step9 >= {1'b0, B}) ? (step9 - B) : step9[7:0];
    assign result[6] = (step9 >= {1'b0, B});
    
    assign step10 = {rem9, A[5]};
    assign rem10 = (step10 >= {1'b0, B}) ? (step10 - B) : step10[7:0];
    assign result[5] = (step10 >= {1'b0, B});
    
    assign step11 = {rem10, A[4]};
    assign rem11 = (step11 >= {1'b0, B}) ? (step11 - B) : step11[7:0];
    assign result[4] = (step11 >= {1'b0, B});
    
    assign step12 = {rem11, A[3]};
    assign rem12 = (step12 >= {1'b0, B}) ? (step12 - B) : step12[7:0];
    assign result[3] = (step12 >= {1'b0, B});
    
    assign step13 = {rem12, A[2]};
    assign rem13 = (step13 >= {1'b0, B}) ? (step13 - B) : step13[7:0];
    assign result[2] = (step13 >= {1'b0, B});
    
    assign step14 = {rem13, A[1]};
    assign rem14 = (step14 >= {1'b0, B}) ? (step14 - B) : step14[7:0];
    assign result[1] = (step14 >= {1'b0, B});
    
    assign step15 = {rem14, A[0]};
    assign rem15 = (step15 >= {1'b0, B}) ? (step15 - B) : step15[7:0];
    assign result[0] = (step15 >= {1'b0, B});
    
    // Final remainder output (zero-extended to 16 bits)
    assign odd = {8'b0, rem15};

endmodule