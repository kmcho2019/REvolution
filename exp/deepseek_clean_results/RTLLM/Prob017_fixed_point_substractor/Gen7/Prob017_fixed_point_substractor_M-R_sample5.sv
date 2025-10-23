module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c,
    output wire overflow,
    output wire underflow,
    output wire zero
);

    // Internal signals
    wire signed [N-1:0] raw_diff;
    wire a_sign, b_sign;
    wire diff_sign;
    wire same_sign;
    wire pos_overflow, neg_underflow;

    // Sign bits
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign diff_sign = raw_diff[N-1];

    // Core subtraction
    assign raw_diff = a - b;
    assign same_sign = (a_sign == b_sign);

    // Overflow/underflow conditions
    assign pos_overflow = (~a_sign & b_sign & diff_sign);  // Positive - Negative = Negative (overflow)
    assign neg_underflow = (a_sign & ~b_sign & ~diff_sign); // Negative - Positive = Positive (underflow)

    // Output assignments
    assign c = (pos_overflow) ? {1'b0, {(N-1){1'b1}}} :  // Saturate to max positive
               (neg_underflow) ? {1'b1, {(N-1){1'b0}}} : // Saturate to min negative
               raw_diff;

    // Status flags
    assign overflow = pos_overflow;
    assign underflow = neg_underflow;
    assign zero = (raw_diff == 0);

endmodule