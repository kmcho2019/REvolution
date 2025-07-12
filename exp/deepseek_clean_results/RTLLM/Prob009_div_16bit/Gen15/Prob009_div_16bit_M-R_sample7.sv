module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire zero_divisor = (B == 8'b0);
    
    // Step 0
    wire [8:0] step0_in = {1'b0, A[15]};
    wire step0_ge = (zero_divisor) ? 1'b0 : (step0_in >= {1'b0, B});
    wire [7:0] step0_rem = (zero_divisor) ? 8'b0 : 
                          (step0_ge ? (step0_in - B) : step0_in[7:0]);
    wire quotient_bit15 = step0_ge;
    
    // Step 1
    wire [8:0] step1_in = {step0_rem, A[14]};
    wire step1_ge = (zero_divisor) ? 1'b0 : (step1_in >= {1'b0, B});
    wire [7:0] step1_rem = (zero_divisor) ? 8'b0 : 
                          (step1_ge ? (step1_in - B) : step1_in[7:0]);
    wire quotient_bit14 = step1_ge;
    
    // Step 2
    wire [8:0] step2_in = {step1_rem, A[13]};
    wire step2_ge = (zero_divisor) ? 1'b0 : (step2_in >= {1'b0, B});
    wire [7:0] step2_rem = (zero_divisor) ? 8'b0 : 
                          (step2_ge ? (step2_in - B) : step2_in[7:0]);
    wire quotient_bit13 = step2_ge;
    
    // Step 3
    wire [8:0] step3_in = {step2_rem, A[12]};
    wire step3_ge = (zero_divisor) ? 1'b0 : (step3_in >= {1'b0, B});
    wire [7:0] step3_rem = (zero_divisor) ? 8'b0 : 
                          (step3_ge ? (step3_in - B) : step3_in[7:0]);
    wire quotient_bit12 = step3_ge;
    
    // Step 4
    wire [8:0] step4_in = {step3_rem, A[11]};
    wire step4_ge = (zero_divisor) ? 1'b0 : (step4_in >= {1'b0, B});
    wire [7:0] step4_rem = (zero_divisor) ? 8'b0 : 
                          (step4_ge ? (step4_in - B) : step4_in[7:0]);
    wire quotient_bit11 = step4_ge;
    
    // Step 5
    wire [8:0] step5_in = {step4_rem, A[10]};
    wire step5_ge = (zero_divisor) ? 1'b0 : (step5_in >= {1'b0, B});
    wire [7:0] step5_rem = (zero_divisor) ? 8'b0 : 
                          (step5_ge ? (step5_in - B) : step5_in[7:0]);
    wire quotient_bit10 = step5_ge;
    
    // Step 6
    wire [8:0] step6_in = {step5_rem, A[9]};
    wire step6_ge = (zero_divisor) ? 1'b0 : (step6_in >= {1'b0, B});
    wire [7:0] step6_rem = (zero_divisor) ? 8'b0 : 
                          (step6_ge ? (step6_in - B) : step6_in[7:0]);
    wire quotient_bit9 = step6_ge;
    
    // Step 7
    wire [8:0] step7_in = {step6_rem, A[8]};
    wire step7_ge = (zero_divisor) ? 1'b0 : (step7_in >= {1'b0, B});
    wire [7:0] step7_rem = (zero_divisor) ? 8'b0 : 
                          (step7_ge ? (step7_in - B) : step7_in[7:0]);
    wire quotient_bit8 = step7_ge;
    
    // Step 8
    wire [8:0] step8_in = {step7_rem, A[7]};
    wire step8_ge = (zero_divisor) ? 1'b0 : (step8_in >= {1'b0, B});
    wire [7:0] step8_rem = (zero_divisor) ? 8'b0 : 
                          (step8_ge ? (step8_in - B) : step8_in[7:0]);
    wire quotient_bit7 = step8_ge;
    
    // Step 9
    wire [8:0] step9_in = {step8_rem, A[6]};
    wire step9_ge = (zero_divisor) ? 1'b0 : (step9_in >= {1'b0, B});
    wire [7:0] step9_rem = (zero_divisor) ? 8'b0 : 
                          (step9_ge ? (step9_in - B) : step9_in[7:0]);
    wire quotient_bit6 = step9_ge;
    
    // Step 10
    wire [8:0] step10_in = {step9_rem, A[5]};
    wire step10_ge = (zero_divisor) ? 1'b0 : (step10_in >= {1'b0, B});
    wire [7:0] step10_rem = (zero_divisor) ? 8'b0 : 
                           (step10_ge ? (step10_in - B) : step10_in[7:0]);
    wire quotient_bit5 = step10_ge;
    
    // Step 11
    wire [8:0] step11_in = {step10_rem, A[4]};
    wire step11_ge = (zero_divisor) ? 1'b0 : (step11_in >= {1'b0, B});
    wire [7:0] step11_rem = (zero_divisor) ? 8'b0 : 
                           (step11_ge ? (step11_in - B) : step11_in[7:0]);
    wire quotient_bit4 = step11_ge;
    
    // Step 12
    wire [8:0] step12_in = {step11_rem, A[3]};
    wire step12_ge = (zero_divisor) ? 1'b0 : (step12_in >= {1'b0, B});
    wire [7:0] step12_rem = (zero_divisor) ? 8'b0 : 
                           (step12_ge ? (step12_in - B) : step12_in[7:0]);
    wire quotient_bit3 = step12_ge;
    
    // Step 13
    wire [8:0] step13_in = {step12_rem, A[2]};
    wire step13_ge = (zero_divisor) ? 1'b0 : (step13_in >= {1'b0, B});
    wire [7:0] step13_rem = (zero_divisor) ? 8'b0 : 
                           (step13_ge ? (step13_in - B) : step13_in[7:0]);
    wire quotient_bit2 = step13_ge;
    
    // Step 14
    wire [8:0] step14_in = {step13_rem, A[1]};
    wire step14_ge = (zero_divisor) ? 1'b0 : (step14_in >= {1'b0, B});
    wire [7:0] step14_rem = (zero_divisor) ? 8'b0 : 
                           (step14_ge ? (step14_in - B) : step14_in[7:0]);
    wire quotient_bit1 = step14_ge;
    
    // Step 15
    wire [8:0] step15_in = {step14_rem, A[0]};
    wire step15_ge = (zero_divisor) ? 1'b0 : (step15_in >= {1'b0, B});
    wire [7:0] step15_rem = (zero_divisor) ? 8'b0 : 
                           (step15_ge ? (step15_in - B) : step15_in[7:0]);
    wire quotient_bit0 = step15_ge;
    
    // Final outputs
    assign result = {quotient_bit15, quotient_bit14, quotient_bit13, quotient_bit12,
                    quotient_bit11, quotient_bit10, quotient_bit9, quotient_bit8,
                    quotient_bit7, quotient_bit6, quotient_bit5, quotient_bit4,
                    quotient_bit3, quotient_bit2, quotient_bit1, quotient_bit0};
    assign odd = (zero_divisor) ? A[7:0] : step15_rem;

endmodule