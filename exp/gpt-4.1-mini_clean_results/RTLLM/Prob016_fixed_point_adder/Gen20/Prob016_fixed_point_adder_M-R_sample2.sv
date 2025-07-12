module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire [N-1:0] a,            // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second fixed-point operand (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1) : b;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Intermediate magnitude and sign for result
    wire [N-1:0] mag_sum;
    wire        mag_sum_sign;
    
    wire [N-1:0] mag_diff;
    wire        mag_diff_sign;

    // Add magnitudes if signs are equal
    wire [N:0] sum_ext = {1'b0, a_abs} + {1'b0, b_abs};
    assign mag_sum = sum_ext[N-1:0];        // Lower N bits of sum
    assign mag_sum_sign = a_sign;           // Sign same as operands' sign

    // Subtract magnitudes if signs differ
    wire a_gt_b = (a_abs >= b_abs);
    wire [N-1:0] diff = a_gt_b ? (a_abs - b_abs) : (b_abs - a_abs);
    assign mag_diff = diff;
    assign mag_diff_sign = a_gt_b ? a_sign : b_sign;

    // Final magnitude and sign based on sign equality
    wire [N-1:0] mag_result = same_sign ? mag_sum : mag_diff;
    wire         sign_result = same_sign ? mag_sum_sign : mag_diff_sign;

    // Compose final two's complement result
    wire [N-1:0] c_temp = sign_result ? (~mag_result + 1) : mag_result;

    assign c = c_temp;

endmodule