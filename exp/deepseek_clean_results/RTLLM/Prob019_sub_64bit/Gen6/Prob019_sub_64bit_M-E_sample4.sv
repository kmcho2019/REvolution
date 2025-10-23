module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Segment the 64-bit operation into four 16-bit chunks
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];
    
    wire [15:0] B0 = B[15:0];
    wire [15:0] B1 = B[31:16];
    wire [15:0] B2 = B[47:32];
    wire [15:0] B3 = B[63:48];
    
    // Compute all possible carry scenarios for each segment
    wire [15:0] sum0, sum1_c0, sum1_c1, sum2_c0, sum2_c1, sum3_c0, sum3_c1;
    wire carry0, carry1_c0, carry1_c1, carry2_c0, carry2_c1;
    
    // First segment (no carry in)
    assign {carry0, sum0} = A0 - B0;
    
    // Second segment (both carry possibilities)
    assign {carry1_c0, sum1_c0} = A1 - B1 - 0;
    assign {carry1_c1, sum1_c1} = A1 - B1 - 1;
    
    // Third segment (both carry possibilities)
    assign {carry2_c0, sum2_c0} = A2 - B2 - 0;
    assign {carry2_c1, sum2_c1} = A2 - B2 - 1;
    
    // Fourth segment (both carry possibilities)
    assign sum3_c0 = A3 - B3 - 0;
    assign sum3_c1 = A3 - B3 - 1;
    
    // Select correct results based on propagated carries
    wire carry1 = carry0 ? carry1_c1 : carry1_c0;
    wire carry2 = carry1 ? carry2_c1 : carry2_c0;
    
    wire [15:0] sum1 = carry0 ? sum1_c1 : sum1_c0;
    wire [15:0] sum2 = carry1 ? sum2_c1 : sum2_c0;
    wire [15:0] sum3 = carry2 ? sum3_c1 : sum3_c0;
    
    // Combine final result
    assign result = {sum3, sum2, sum1, sum0};
    
    // Early overflow prediction (only needs MSB segments)
    wire A_sign = A3[15];
    wire B_sign = B3[15];
    wire res_sign = sum3[15];
    
    // Overflow occurs when signs of A and -B differ and result sign differs from A
    assign overflow = (A_sign != B_sign) && (res_sign != A_sign);

endmodule