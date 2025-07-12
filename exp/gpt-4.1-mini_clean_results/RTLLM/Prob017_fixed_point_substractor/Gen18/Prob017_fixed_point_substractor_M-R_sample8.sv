`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire [N-1:0] a,    // Fixed-point input operand (two's complement)
    input  wire [N-1:0] b,
    output wire [N-1:0] c     // Fixed-point output operand
);

    // Extract signs as 1-bit signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract magnitudes as signed values (N-1 bits)
    // Convert two's complement to signed magnitude by:
    // If sign=1, magnitude = - (two's complement) value, else positive
    wire signed [N-2:0] a_mag = a_sign ? -$signed(a[N-2:0]) : $signed(a[N-2:0]);
    wire signed [N-2:0] b_mag = b_sign ? -$signed(b[N-2:0]) : $signed(b[N-2:0]);

    // Intermediate signals for result magnitude and sign
    wire signed [N-2:0] res_mag_sub;
    wire signed [N-2:0] res_mag_add;
    wire [N-2:0] res_mag_abs;
    wire res_sign_sub;
    wire res_sign;

    // Same sign subtraction magnitude: a_mag - b_mag
    assign res_mag_sub = a_mag - b_mag;
    // Different sign addition magnitude: a_mag + b_mag
    assign res_mag_add = a_mag + b_mag;

    // Determine result magnitude and sign depending on input sign relation
    wire inputs_same_sign = (a_sign == b_sign);

    // When signs are same:
    //   magnitude is absolute difference of a_mag and b_mag
    //   sign is a_sign if a_mag >= b_mag else inverse of a_sign
    wire a_mag_ge_b_mag = (a_mag >= b_mag);
    wire [N-2:0] mag_diff = a_mag_ge_b_mag ? (a_mag - b_mag) : (b_mag - a_mag);
    wire sign_diff = a_mag_ge_b_mag ? a_sign : ~a_sign;

    // When signs differ:
    //   magnitude is sum of magnitudes (addition)
    //   sign depends on which magnitude is greater
    wire a_mag_gt_b_mag = (a_mag > b_mag);
    wire [N-2:0] mag_sum = a_mag + b_mag;
    wire sign_sum = a_mag_gt_b_mag ? a_sign : b_sign;

    // Select based on sign equality
    wire [N-2:0] res_mag_unsigned = inputs_same_sign ? mag_diff : mag_sum;
    wire       res_sign_prezero = inputs_same_sign ? sign_diff : sign_sum;

    // If magnitude is zero, force sign to zero
    wire zero_mag = (res_mag_unsigned == { (N-1){1'b0} });
    assign res_sign = zero_mag ? 1'b0 : res_sign_prezero;

    // Construct output c in two's complement fixed point:
    // If result sign = 0, c = + magnitude (with leading 0 sign bit)
    // else c = two's complement negation of magnitude
    wire signed [N-1:0] res_signed_mag = {res_sign, res_mag_unsigned};
    wire signed [N-1:0] res_signed_val = res_sign ? -$signed(res_signed_mag) : $signed(res_signed_mag);

    assign c = res_signed_val;

endmodule