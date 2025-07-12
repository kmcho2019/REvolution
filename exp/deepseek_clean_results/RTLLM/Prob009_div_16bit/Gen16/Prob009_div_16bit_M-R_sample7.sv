module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Zero divisor special case
    wire zero_divisor = (B == 8'b0);
    
    // Step 0
    wire [8:0] step0_in = {1'b0, A[15]};
    wire step0_ge = (zero_divisor) ? 1'b0 : (step0_in >= {1'b0, B});
    wire [7:0] step0_rem = step0_ge ? (step0_in - B) : step0_in[7:0];
    wire step0_q = step0_ge;
    
    // Step 1
    wire [8:0] step1_in = {step0_rem, A[14]};
    wire step1_ge = (zero_divisor) ? 1'b0 : (step1_in >= {1'b0, B});
    wire [7:0] step1_rem = step1_ge ? (step1_in - B) : step1_in[7:0];
    wire step1_q = step1_ge;
    
    // Step 2
    wire [8:0] step2_in = {step1_rem, A[13]};
    wire step2_ge = (zero_divisor) ? 1'b0 : (step2_in >= {1'b0, B});
    wire [7:0] step2_rem = step2_ge ? (step2_in - B) : step2_in[7:0];
    wire step2_q = step2_ge;
    
    // Step 3
    wire [8:0] step3_in = {step2_rem, A[12]};
    wire step3_ge = (zero_divisor) ? 1'b0 : (step3_in >= {1'b0, B});
    wire [7:0] step3_rem = step3_ge ? (step3_in - B) : step3_in[7:0];
    wire step3_q = step3_ge;
    
    // Step 4
    wire [8:0] step4_in = {step3_rem, A[11]};
    wire step4_ge = (zero_divisor) ? 1'b0 : (step4_in >= {1'b0, B});
    wire [7:0] step4_rem = step4_ge ? (step4_in - B) : step4_in[7:0];
    wire step4_q = step4_ge;
    
    // Step 5
    wire [8:0] step5_in = {step4_rem, A[10]};
    wire step5_ge = (zero_divisor) ? 1'b0 : (step5_in >= {1'b0, B});
    wire [7:0] step5_rem = step5_ge ? (step5_in - B) : step5_in[7:0];
    wire step5_q = step5_ge;
    
    // Step 6
    wire [8:0] step6_in = {step5_rem, A[9]};
    wire step6_ge = (zero_divisor) ? 1'b0 : (step6_in >= {1'b0, B});
    wire [7:0] step6_rem = step6_ge ? (step6_in - B) : step6_in[7:0];
    wire step6_q = step6_ge;
    
    // Step 7
    wire [8:0] step7_in = {step6_rem, A[8]};
    wire step7_ge = (zero_divisor) ? 1'b0 : (step7_in >= {1'b0, B});
    wire [7:0] step7_rem = step7_ge ? (step7_in - B) : step7_in[7:0];
    wire step7_q = step7_ge;
    
    // Step 8
    wire [8:0] step8_in = {step7_rem, A[7]};
    wire step8_ge = (zero_divisor) ? 1'b0 : (step8_in >= {1'b0, B});
    wire [7:0] step8_rem = step8_ge ? (step8_in - B) : step8_in[7:0];
    wire step8_q = step8_ge;
    
    // Step 9
    wire [8:0] step9_in = {step8_rem, A[6]};
    wire step9_ge = (zero_divisor) ? 1'b0 : (step9_in >= {1'b0, B});
    wire [7:0] step9_rem = step9_ge ? (step9_in - B) : step9_in[7:0];
    wire step9_q = step9_ge;
    
    // Step 10
    wire [8:0] step10_in = {step9_rem, A[5]};
    wire step10_ge = (zero_divisor) ? 1'b0 : (step10_in >= {1'b0, B});
    wire [7:0] step10_rem = step10_ge ? (step10_in - B) : step10_in[7:0];
    wire step10_q = step10_ge;
    
    // Step 11
    wire [8:0] step11_in = {step10_rem, A[4]};
    wire step11_ge = (zero_divisor) ? 1'b0 : (step11_in >= {1'b0, B});
    wire [7:0] step11_rem = step11_ge ? (step11_in - B) : step11_in[7:0];
    wire step11_q = step11_ge;
    
    // Step 12
    wire [8:0] step12_in = {step11_rem, A[3]};
    wire step12_ge = (zero_divisor) ? 1'b0 : (step12_in >= {1'b0, B});
    wire [7:0] step12_rem = step12_ge ? (step12_in - B) : step12_in[7:0];
    wire step12_q = step12_ge;
    
    // Step 13
    wire [8:0] step13_in = {step12_rem, A[2]};
    wire step13_ge = (zero_divisor) ? 1'b0 : (step13_in >= {1'b0, B});
    wire [7:0] step13_rem = step13_ge ? (step13_in - B) : step13_in[7:0];
    wire step13_q = step13_ge;
    
    // Step 14
    wire [8:0] step14_in = {step13_rem, A[1]};
    wire step14_ge = (zero_divisor) ? 1'b0 : (step14_in >= {1'b0, B});
    wire [7:0] step14_rem = step14_ge ? (step14_in - B) : step14_in[7:0];
    wire step14_q = step14_ge;
    
    // Step 15
    wire [8:0] step15_in = {step14_rem, A[0]};
    wire step15_ge = (zero_divisor) ? 1'b0 : (step15_in >= {1'b0, B});
    wire [7:0] step15_rem = step15_ge ? (step15_in - B) : step15_in[7:0];
    wire step15_q = step15_ge;
    
    // Combine quotient bits
    assign result = {step0_q, step1_q, step2_q, step3_q, step4_q, step5_q, step6_q, step7_q,
                    step8_q, step9_q, step10_q, step11_q, step12_q, step13_q, step14_q, step15_q};
    
    // Final remainder
    assign odd = (zero_divisor) ? A[7:0] : step15_rem;

endmodule