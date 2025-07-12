module fixed_point_adder #(
    parameter integer N = 16,      // Total width (including sign bit)
    parameter integer Q = 8        // Number of fractional bits (for info, no direct effect)
) (
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c          // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Calculate absolute values (magnitude) via two's complement if negative
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Check if signs are equal
    wire signs_equal = (a_sign == b_sign);

    // Sum of absolute values with one extra bit to capture carry
    wire [N:0] abs_sum = {1'b0, a_abs} + {1'b0, b_abs};

    // Determine which operand has the larger magnitude
    wire a_greater_equal = (a_abs >= b_abs);

    // Magnitude difference for subtraction case
    wire [N-1:0] abs_diff = a_greater_equal ? (a_abs - b_abs) : (b_abs - a_abs);

    // Compute magnitude result depending on sign condition
    wire [N-1:0] mag_result = signs_equal ? abs_sum[N-1:0] : abs_diff;

    // Determine result sign:
    // If signs equal, result sign matches inputs.
    // If signs differ, sign is sign of operand with larger magnitude unless result zero (positive zero).
    wire result_sign = signs_equal ? a_sign :
                       (mag_result == 0 ? 1'b0 : (a_greater_equal ? a_sign : b_sign));

    // Convert magnitude and sign back to two's complement representation
    wire [N-1:0] signed_result = result_sign ? (~mag_result + 1'b1) : mag_result;

    // Assign the final output
    assign c = signed_result;

endmodule