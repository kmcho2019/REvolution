module fixed_point_adder #(
    parameter integer N = 16, // Total bits (integer + fractional + sign)
    parameter integer Q = 8   // Fractional bits (precision)
)(
    input  wire [N-1:0] a,    // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,    // Fixed-point operand b (two's complement)
    output wire [N-1:0] c     // Result of addition
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    // If sign is 1, abs = two's complement negation; else abs = a or b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Magnitude comparison
    wire a_greater_or_equal = (a_abs >= b_abs);

    // Intermediate magnitude result and sign
    wire [N-1:0] magnitude_sum = a_abs + b_abs;
    wire [N-1:0] magnitude_diff = a_greater_or_equal ? (a_abs - b_abs) : (b_abs - a_abs);

    // Result sign selection and magnitude selection
    // Case 1: same sign -> add, sign = a_sign (or b_sign, same)
    // Case 2: different sign -> subtract smaller from bigger, sign = sign of bigger magnitude

    wire result_sign = (a_sign == b_sign) ? a_sign : (a_greater_or_equal ? a_sign : b_sign);
    wire [N-1:0] magnitude_result = (a_sign == b_sign) ? magnitude_sum : magnitude_diff;

    // Handle zero magnitude: if magnitude_result is zero, sign forced to 0
    wire magnitude_is_zero = (magnitude_result == {N{1'b0}});
    wire final_sign = magnitude_is_zero ? 1'b0 : result_sign;

    // Form final result by applying sign (two's complement if sign == 1)
    // If sign == 1, result = -magnitude_result; else = magnitude_result
    wire [N-1:0] res = final_sign ? (~magnitude_result + 1'b1) : magnitude_result;

    assign c = res;

endmodule