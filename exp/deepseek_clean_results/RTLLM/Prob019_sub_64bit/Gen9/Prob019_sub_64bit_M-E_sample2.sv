module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Stage 0: Input analysis and special case detection
    logic [63:0] B_comp;  // Two's complement of B
    logic [63:0] B_final; // Final value to add (B or ~B+1)
    logic A_sign, B_sign;
    logic possible_overflow;

    // Stage 1: 16-bit chunks
    logic [15:0] sum0, sum1, sum2, sum3;
    logic carry0, carry1, carry2, carry3;

    // Stage 2: Intermediate results
    logic [63:0] partial_sum;
    logic final_carry;

    // Special case detection (A == B)
    wire equal = (A == B);

    always_comb begin
        // Input analysis (parallel with subtraction)
        A_sign = A[63];
        B_sign = B[63];
        possible_overflow = (A_sign ^ B_sign);
        
        // Two's complement of B (for subtraction)
        B_comp = ~B + 1'b1;
        
        // Special case handling
        if (equal) begin
            result = 64'b0;
            overflow = 1'b0;
        end
        else begin
            // Carry-save subtraction (4x16-bit chunks)
            {carry0, sum0} = A[15:0] + B_comp[15:0];
            {carry1, sum1} = A[31:16] + B_comp[31:16] + carry0;
            {carry2, sum2} = A[47:32] + B_comp[47:32] + carry1;
            {carry3, sum3} = A[63:48] + B_comp[63:48] + carry2;
            
            // Combine results
            partial_sum = {sum3, sum2, sum1, sum0};
            final_carry = carry3;
            
            // Final result
            result = partial_sum;
            
            // Overflow detection (parallel computation)
            overflow = possible_overflow && (A_sign ^ result[63]);
        end
    end

endmodule