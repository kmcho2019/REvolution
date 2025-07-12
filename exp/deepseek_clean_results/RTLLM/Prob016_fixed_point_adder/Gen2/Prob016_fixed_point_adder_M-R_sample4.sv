module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N-1:0] raw_sum;
    wire sign_a, sign_b, sign_sum;
    wire overflow_positive, overflow_negative;

    // Sign bits
    assign sign_a = a[N-1];
    assign sign_b = b[N-1];

    // Direct addition
    assign raw_sum = a + b;
    assign sign_sum = raw_sum[N-1];

    // Overflow detection
    assign overflow_positive = (~sign_a & ~sign_b & sign_sum);
    assign overflow_negative = (sign_a & sign_b & ~sign_sum);

    // Result with saturation
    assign c = overflow_positive ? {1'b0, {(N-1){1'b1}}} :  // Max positive
              overflow_negative ? {1'b1, {(N-1){1'b0}}} :  // Max negative
              raw_sum;                                      // Normal result

endmodule