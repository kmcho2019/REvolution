module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement conversion with XOR (no explicit inversion)
    wire [63:0] B_comp = B ^ {64{1'b1}};
    wire cin = 1'b1;  // For the +1 in two's complement

    // Conditional Sum Adder for lower 32 bits
    wire [31:0] sum0, sum1;
    wire cout0, cout1;
    
    // Compute both possible sums (cin=0 and cin=1)
    assign {cout0, sum0} = A[31:0] + B_comp[31:0] + 1'b0;
    assign {cout1, sum1} = A[31:0] + B_comp[31:0] + 1'b1;
    
    // Select correct sum based on actual cin
    wire [31:0] lower_sum = cin ? sum1 : sum0;
    wire lower_cout = cin ? cout1 : cout0;

    // Carry-Select Adder for upper 32 bits
    wire [31:0] upper_sum0, upper_sum1;
    wire upper_cout0, upper_cout1;
    
    // Compute both possible upper sums
    assign {upper_cout0, upper_sum0} = A[63:32] + B_comp[63:32] + 1'b0;
    assign {upper_cout1, upper_sum1} = A[63:32] + B_comp[63:32] + lower_cout;
    
    // Select correct upper sum
    wire [31:0] upper_sum = lower_cout ? upper_sum1 : upper_sum0;
    wire final_cout = lower_cout ? upper_cout1 : upper_cout0;

    // Combine results
    assign result = {upper_sum, lower_sum};

    // Early Overflow Detection (computed in parallel)
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire predicted_sign = (A_sign ^ B_sign) ? 
                         (A_sign ^ (A[62:0] < B[62:0])) : 
                         (A_sign ^ (final_cout != A_sign));
    
    // Overflow occurs if:
    // 1. Signs of A and B differ (potential overflow)
    // 2. Result sign doesn't match prediction
    assign overflow = (A_sign != B_sign) && (predicted_sign != result[63]);

    /* Overflow Detection Explanation:
     * - For A positive, B negative: result should be positive (A_sign != B_sign)
     *   If result is negative, positive overflow occurred
     * - For A negative, B positive: result should be negative (A_sign != B_sign)
     *   If result is positive, negative overflow occurred
     * - Parallel computation predicts this condition early
     */
endmodule