module fixed_point_adder #(
    parameter integer N = 16,   // Total number of bits (including sign)
    parameter integer Q = 8     // Fractional bits (interface parameter)
)(
    input  wire [N-1:0] a,      // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c       // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Are the signs equal?
    wire signs_equal = (a_sign == b_sign);

    // Sum of absolute values (one extra bit for carry)
    wire [N:0] abs_sum = {1'b0, a_abs} + {1'b0, b_abs};

    // Compare absolute values
    wire a_ge_b = (a_abs >= b_abs);

    // Difference of absolute values
    wire [N-1:0] abs_diff = a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Result magnitude depends on sign equality
    wire [N-1:0] res_mag = signs_equal ? abs_sum[N-1:0] : abs_diff;

    // Result sign logic
    wire res_sign = signs_equal ? a_sign : (a_ge_b ? a_sign :
                        (abs_diff == 0 ? 1'b0 : b_sign));

    // Compose the final two's complement output
    wire [N-1:0] res_twos_complement = res_sign ? (~res_mag + 1'b1) : res_mag;

    // Assign the output
    assign c = res_twos_complement;

endmodule