module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire [N-1:0] a,            // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second fixed-point operand (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Two's complement negation function (as localparam function not possible,
    // use inline expression)
    wire [N-1:0] a_neg = (~a) + 1'b1;
    wire [N-1:0] b_neg = (~b) + 1'b1;

    // Absolute value calculation using sign
    wire [N-1:0] a_abs = a_sign ? a_neg : a;
    wire [N-1:0] b_abs = b_sign ? b_neg : b;

    // Add absolute values
    wire [N:0] abs_sum_ext = {1'b0, a_abs} + {1'b0, b_abs}; // One extra bit to detect overflow

    // Subtract absolute values
    wire [N:0] abs_diff_ab = {1'b0, a_abs} - {1'b0, b_abs};
    wire [N:0] abs_diff_ba = {1'b0, b_abs} - {1'b0, a_abs};

    // Decide operation based on sign bits
    // If signs are same -> addition with that sign
    // If different -> subtraction between abs values

    // When signs differ, determine which operand has larger absolute value
    wire a_abs_gte_b_abs = (a_abs >= b_abs);

    // Intermediate magnitude and sign for subtraction case
    wire [N-1:0] sub_mag = a_abs_gte_b_abs ? abs_diff_ab[N-1:0] : abs_diff_ba[N-1:0];
    wire sub_zero = (sub_mag == 0);

    wire sub_sign = a_abs_gte_b_abs ? a_sign : b_sign;

    // Compose final result
    // When signs are equal: add absolute values, sign is a_sign/b_sign
    // Handle overflow by truncation (wrap-around) to N bits
    wire [N-1:0] add_mag = abs_sum_ext[N-1:0];

    wire same_sign = (a_sign == b_sign);

    // Final sign bit
    wire result_sign = same_sign ? a_sign : (sub_zero ? 1'b0 : sub_sign);

    // Final magnitude bits
    wire [N-2:0] result_mag = same_sign ? add_mag[N-2:0] : sub_mag[N-2:0];

    // Construct final result
    wire [N-1:0] res = {result_sign, result_mag};

    // Assign output
    assign c = res;

endmodule