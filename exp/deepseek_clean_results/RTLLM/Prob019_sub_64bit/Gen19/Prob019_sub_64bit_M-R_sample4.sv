module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Constants for overflow states
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    // Two's complement subtraction components
    wire [63:0] B_complement = ~B;
    wire [63:0] carry_in;
    wire [63:0] carry_out;
    wire [63:0] sum_bits;

    // Initialize first carry-in for subtraction (A - B = A + ~B + 1)
    assign carry_in[0] = 1'b1;

    // Ripple-carry subtraction implementation
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : SUB_BITS
            // Current bit subtraction
            assign sum_bits[i] = A[i] ^ B_complement[i] ^ carry_in[i];
            
            // Carry out calculation
            assign carry_out[i] = (A[i] & B_complement[i]) | 
                                ((A[i] ^ B_complement[i]) & carry_in[i]);
            
            // Propagate carry to next bit (except for last bit)
            if (i < 63) begin
                assign carry_in[i+1] = carry_out[i];
            end
        end
    endgenerate

    // Final result assignment
    assign result = sum_bits;

    // Overflow detection (same logic, different expression)
    wire operands_diff_sign = A[63] ^ B[63];
    wire result_diff_sign = A[63] ^ result[63];
    assign overflow = operands_diff_sign & result_diff_sign;

    /* Overflow explanation (same as original):
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Detected when signs of A/B differ AND result sign differs from A
     */
endmodule