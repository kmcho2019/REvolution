module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract magnitudes (absolute values) of a and b (N-1 bits)
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Same sign addition: sum magnitudes with 1-bit extension for carry
    wire [N-1:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Different sign subtraction: magnitude difference with 1-bit extension
    wire [N-1:0] mag_diff_ab = {1'b0, mag_a} - {1'b0, mag_b};
    wire [N-1:0] mag_diff_ba = {1'b0, mag_b} - {1'b0, mag_a};

    // Determine which magnitude is greater for different sign case
    wire a_greater_eq_b = (mag_a >= mag_b);

    // Compute result sign and magnitude based on input signs and magnitudes
    wire res_sign = (sign_a == sign_b) ? sign_a : (a_greater_eq_b ? sign_a : sign_b);

    wire [N-2:0] res_mag = (sign_a == sign_b)
                          ? mag_sum[N-2:0]
                          : (a_greater_eq_b ? mag_diff_ab[N-2:0] : mag_diff_ba[N-2:0]);

    // If magnitude is zero, force sign to zero (positive)
    wire zero_mag = (res_mag == { (N-1){1'b0} });
    wire final_sign = zero_mag ? 1'b0 : res_sign;

    // Reconstruct two's complement result
    assign c = final_sign ? {1'b1, (~res_mag + 1'b1)} : {1'b0, res_mag};

endmodule