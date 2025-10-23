module fixed_point_adder #(
    parameter integer N = 16,      // Total fixed-point width (including sign bit)
    parameter integer Q = 8        // Number of fractional bits (informational)
) (
    input  wire [N-1:0] a,         // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c          // Fixed-point output result (two's complement)
);

    // Extract sign bits from inputs (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Calculate absolute values of inputs using two's complement conversion if negative
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Check if signs are equal (both positive or both negative)
    wire signs_equal = (a_sign == b_sign);

    // Add absolute values with extra bit for carry
    wire [N:0] abs_sum = {1'b0, a_abs} + {1'b0, b_abs};

    // Compare magnitudes
    wire a_greater_equal = (a_abs >= b_abs);

    // Absolute difference for subtraction case
    wire [N-1:0] abs_diff = a_greater_equal ? (a_abs - b_abs) : (b_abs - a_abs);

    // Determine magnitude of the result
    wire [N-1:0] mag_result = signs_equal ? abs_sum[N-1:0] : abs_diff;

    // Determine sign of the result
    // If signs equal, keep input sign.
    // If signs differ, sign is of larger magnitude input; zero treated as positive.
    wire result_sign = signs_equal ? a_sign :
                       ((mag_result == {N{1'b0}}) ? 1'b0 :
                       (a_greater_equal ? a_sign : b_sign));

    // Convert back to two's complement representation based on sign
    wire [N-1:0] signed_result = result_sign ? (~mag_result + 1'b1) : mag_result;

    // Assign output
    assign c = signed_result;

endmodule

/*
Example instantiation in a testbench or higher-level module:

fixed_point_adder #(
    .N(16),
    .Q(8)
) u_fixed_point_adder (
    .a(input_a),
    .b(input_b),
    .c(output_c)
);

Ensure to pass parameters explicitly if different from defaults to avoid elaboration errors.
*/