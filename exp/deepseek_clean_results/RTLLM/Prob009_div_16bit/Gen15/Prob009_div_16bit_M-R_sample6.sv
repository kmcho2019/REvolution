module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire zero_divisor = (B == 8'b0);
    
    // Division steps implemented as direct chained operations
    wire [8:0] step0 = {1'b0, A[15]};
    wire ge0 = (zero_divisor) ? 1'b0 : (step0 >= {1'b0, B});
    wire [7:0] rem0 = ge0 ? (step0 - B) : step0[7:0];
    
    wire [8:0] step1 = {rem0, A[14]};
    wire ge1 = (zero_divisor) ? 1'b0 : (step1 >= {1'b0, B});
    wire [7:0] rem1 = ge1 ? (step1 - B) : step1[7:0];
    
    wire [8:0] step2 = {rem1, A[13]};
    wire ge2 = (zero_divisor) ? 1'b0 : (step2 >= {1'b0, B});
    wire [7:0] rem2 = ge2 ? (step2 - B) : step2[7:0];
    
    wire [8:0] step3 = {rem2, A[12]};
    wire ge3 = (zero_divisor) ? 1'b0 : (step3 >= {1'b0, B});
    wire [7:0] rem3 = ge3 ? (step3 - B) : step3[7:0];
    
    wire [8:0] step4 = {rem3, A[11]};
    wire ge4 = (zero_divisor) ? 1'b0 : (step4 >= {1'b0, B});
    wire [7:0] rem4 = ge4 ? (step4 - B) : step4[7:0];
    
    wire [8:0] step5 = {rem4, A[10]};
    wire ge5 = (zero_divisor) ? 1'b0 : (step5 >= {1'b0, B});
    wire [7:0] rem5 = ge5 ? (step5 - B) : step5[7:0];
    
    wire [8:0] step6 = {rem5, A[9]};
    wire ge6 = (zero_divisor) ? 1'b0 : (step6 >= {1'b0, B});
    wire [7:0] rem6 = ge6 ? (step6 - B) : step6[7:0];
    
    wire [8:0] step7 = {rem6, A[8]};
    wire ge7 = (zero_divisor) ? 1'b0 : (step7 >= {1'b0, B});
    wire [7:0] rem7 = ge7 ? (step7 - B) : step7[7:0];
    
    wire [8:0] step8 = {rem7, A[7]};
    wire ge8 = (zero_divisor) ? 1'b0 : (step8 >= {1'b0, B});
    wire [7:0] rem8 = ge8 ? (step8 - B) : step8[7:0];
    
    wire [8:0] step9 = {rem8, A[6]};
    wire ge9 = (zero_divisor) ? 1'b0 : (step9 >= {1'b0, B});
    wire [7:0] rem9 = ge9 ? (step9 - B) : step9[7:0];
    
    wire [8:0] step10 = {rem9, A[5]};
    wire ge10 = (zero_divisor) ? 1'b0 : (step10 >= {1'b0, B});
    wire [7:0] rem10 = ge10 ? (step10 - B) : step10[7:0];
    
    wire [8:0] step11 = {rem10, A[4]};
    wire ge11 = (zero_divisor) ? 1'b0 : (step11 >= {1'b0, B});
    wire [7:0] rem11 = ge11 ? (step11 - B) : step11[7:0];
    
    wire [8:0] step12 = {rem11, A[3]};
    wire ge12 = (zero_divisor) ? 1'b0 : (step12 >= {1'b0, B});
    wire [7:0] rem12 = ge12 ? (step12 - B) : step12[7:0];
    
    wire [8:0] step13 = {rem12, A[2]};
    wire ge13 = (zero_divisor) ? 1'b0 : (step13 >= {1'b0, B});
    wire [7:0] rem13 = ge13 ? (step13 - B) : step13[7:0];
    
    wire [8:0] step14 = {rem13, A[1]};
    wire ge14 = (zero_divisor) ? 1'b0 : (step14 >= {1'b0, B});
    wire [7:0] rem14 = ge14 ? (step14 - B) : step14[7:0];
    
    wire [8:0] step15 = {rem14, A[0]};
    wire ge15 = (zero_divisor) ? 1'b0 : (step15 >= {1'b0, B});
    wire [7:0] rem15 = ge15 ? (step15 - B) : step15[7:0];
    
    // Combine quotient bits
    assign result = zero_divisor ? 16'b0 : {
        ge0, ge1, ge2, ge3, ge4, ge5, ge6, ge7,
        ge8, ge9, ge10, ge11, ge12, ge13, ge14, ge15
    };
    
    assign odd = zero_divisor ? A[7:0] : rem15;

endmodule