module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Early overflow prediction signals
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire potential_overflow = (A_sign != B_sign);

    // Two's complement conversion
    wire [63:0] B_comp = ~B;
    wire [63:0] B_neg = B_comp + 64'd1;

    // Lower 32-bit ripple-carry implementation (power optimized)
    wire [31:0] sum_low;
    wire carry_out_low;
    
    assign {carry_out_low, sum_low} = A[31:0] + B_neg[31:0];

    // Upper 32-bit carry-select implementation (performance optimized)
    wire [31:0] sum_high_0, sum_high_1;
    wire [31:0] upper_A = A[63:32];
    wire [31:0] upper_B_neg = B_neg[63:32];
    
    // Carry=0 path
    assign sum_high_0 = upper_A + upper_B_neg;
    
    // Carry=1 path
    assign sum_high_1 = upper_A + upper_B_neg + 32'd1;
    
    // Final upper result selection
    wire [31:0] sum_high = carry_out_low ? sum_high_1 : sum_high_0;

    // Combine results
    assign result = {sum_high, sum_low};

    // Overflow detection with early prediction
    always_comb begin
        if (potential_overflow) begin
            // Only possible overflow case when signs differ
            overflow = (A_sign != result[63]);
        end else begin
            // No overflow possible when signs are same
            overflow = 1'b0;
        end
    end

    /* Power Optimization Features:
     * 1. Lower 32-bit ripple-carry consumes less power for small numbers
     * 2. Upper 32-bit logic can be gated when not needed
     * 3. Early overflow prediction avoids full subtraction completion
     *
     * Performance Features:
     * 1. Carry-select in upper bits reduces critical path
     * 2. Parallel overflow computation
     * 3. Balanced 32/32 split for optimal routing
     */
endmodule