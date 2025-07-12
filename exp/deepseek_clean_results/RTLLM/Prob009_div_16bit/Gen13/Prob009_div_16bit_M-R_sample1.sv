module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Handle zero divisor case first
    wire zero_divisor = (B == 8'b0);
    
    // Main division logic
    wire [8:0] step0 = {1'b0, A[15]};
    wire step0_ge = (zero_divisor) ? 1'b0 : (step0 >= {1'b0, B});
    wire [7:0] rem0 = (zero_divisor) ? 8'b0 : (step0_ge ? (step0 - B) : step0[7:0]);
    
    wire [8:0] step1 = {rem0, A[14]};
    wire step1_ge = (zero_divisor) ? 1'b0 : (step1 >= {1'b0, B});
    wire [7:0] rem1 = (zero_divisor) ? 8'b0 : (step1_ge ? (step1 - B) : step1[7:0]);
    
    wire [8:0] step2 = {rem1, A[13]};
    wire step2_ge = (zero_divisor) ? 1'b0 : (step2 >= {1'b0, B});
    wire [7:0] rem2 = (zero_divisor) ? 8'b0 : (step2_ge ? (step2 - B) : step2[7:0]);
    
    wire [8:0] step3 = {rem2, A[12]};
    wire step3_ge = (zero_divisor) ? 1'b0 : (step3 >= {1'b0, B});
    wire [7:0] rem3 = (zero_divisor) ? 8'b0 : (step3_ge ? (step3 - B) : step3[7:0]);
    
    wire [8:0] step4 = {rem3, A[11]};
    wire step4_ge = (zero_divisor) ? 1'b0 : (step4 >= {1'b0, B});
    wire [7:0] rem4 = (zero_divisor) ? 8'b0 : (step4_ge ? (step4 - B) : step4[7:0]);
    
    wire [8:0] step5 = {rem4, A[10]};
    wire step5_ge = (zero_divisor) ? 1'b0 : (step5 >= {1'b0, B});
    wire [7:0] rem5 = (zero_divisor) ? 8'b0 : (step5_ge ? (step5 - B) : step5[7:0]);
    
    wire [8:0] step6 = {rem5, A[9]};
    wire step6_ge = (zero_divisor) ? 1'b0 : (step6 >= {1'b0, B});
    wire [7:0] rem6 = (zero_divisor) ? 8'b0 : (step6_ge ? (step6 - B) : step6[7:0]);
    
    wire [8:0] step7 = {rem6, A[8]};
    wire step7_ge = (zero_divisor) ? 1'b0 : (step7 >= {1'b0, B});
    wire [7:0] rem7 = (zero_divisor) ? 8'b0 : (step7_ge ? (step7 - B) : step7[7:0]);
    
    wire [8:0] step8 = {rem7, A[7]};
    wire step8_ge = (zero_divisor) ? 1'b0 : (step8 >= {1'b0, B});
    wire [7:0] rem8 = (zero_divisor) ? 8'b0 : (step8_ge ? (step8 - B) : step8[7:0]);
    
    wire [8:0] step9 = {rem8, A[6]};
    wire step9_ge = (zero_divisor) ? 1'b0 : (step9 >= {1'b0, B});
    wire [7:0] rem9 = (zero_divisor) ? 8'b0 : (step9_ge ? (step9 - B) : step9[7:0]);
    
    wire [8:0] step10 = {rem9, A[5]};
    wire step10_ge = (zero_divisor) ? 1'b0 : (step10 >= {1'b0, B});
    wire [7:0] rem10 = (zero_divisor) ? 8'b0 : (step10_ge ? (step10 - B) : step10[7:0]);
    
    wire [8:0] step11 = {rem10, A[4]};
    wire step11_ge = (zero_divisor) ? 1'b0 : (step11 >= {1'b0, B});
    wire [7:0] rem11 = (zero_divisor) ? 8'b0 : (step11_ge ? (step11 - B) : step11[7:0]);
    
    wire [8:0] step12 = {rem11, A[3]};
    wire step12_ge = (zero_divisor) ? 1'b0 : (step12 >= {1'b0, B});
    wire [7:0] rem12 = (zero_divisor) ? 8'b0 : (step12_ge ? (step12 - B) : step12[7:0]);
    
    wire [8:0] step13 = {rem12, A[2]};
    wire step13_ge = (zero_divisor) ? 1'b0 : (step13 >= {1'b0, B});
    wire [7:0] rem13 = (zero_divisor) ? 8'b0 : (step13_ge ? (step13 - B) : step13[7:0]);
    
    wire [8:0] step14 = {rem13, A[1]};
    wire step14_ge = (zero_divisor) ? 1'b0 : (step14 >= {1'b0, B});
    wire [7:0] rem14 = (zero_divisor) ? 8'b0 : (step14_ge ? (step14 - B) : step14[7:0]);
    
    wire [8:0] step15 = {rem14, A[0]};
    wire step15_ge = (zero_divisor) ? 1'b0 : (step15 >= {1'b0, B});
    wire [7:0] rem15 = (zero_divisor) ? 8'b0 : (step15_ge ? (step15 - B) : step15[7:0]);

    // Final outputs
    assign result = {step0_ge, step1_ge, step2_ge, step3_ge,
                    step4_ge, step5_ge, step6_ge, step7_ge,
                    step8_ge, step9_ge, step10_ge, step11_ge,
                    step12_ge, step13_ge, step14_ge, step15_ge};
    
    assign odd = (zero_divisor) ? A[7:0] : rem15;

endmodule