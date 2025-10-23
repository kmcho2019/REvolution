module fixed_point_adder #(
    parameter integer N = 16,       // Total bits (including sign)
    parameter integer Q = 8         // Fractional bits (interface purpose)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c           // Fixed-point output result
);

    // Sign extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute value computation (two's complement magnitude)
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Check if signs are equal
    wire signs_equal = (a_sign == b_sign);

    // Addition of magnitudes (N+1 bits to catch carry)
    wire [N:0] sum_abs = {1'b0, a_abs} + {1'b0, b_abs};

    // Comparison of magnitudes for subtraction
    wire a_greater = (a_abs >= b_abs);
    wire [N-1:0] diff_abs = a_greater ? (a_abs - b_abs) : (b_abs - a_abs);

    // Result magnitude depending on signs
    wire [N-1:0] mag_result = signs_equal ? sum_abs[N-1:0] : diff_abs;

    // Result sign depending on signs and magnitude
    wire result_sign;
    assign result_sign = signs_equal ? a_sign :
                         (mag_result == 0 ? 1'b0 : (a_greater ? a_sign : b_sign));

    // Compose final result in two's complement form
    wire [N-1:0] signed_result = result_sign ? (~mag_result + 1'b1) : mag_result;

    // Assign final output
    assign c = signed_result;

endmodule