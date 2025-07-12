`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total bits including sign
    parameter integer Q = 8         // Fractional bits (not used in logic but for context)
)(
    input  wire [N-1:0] a,          // Input operand a (two's complement)
    input  wire [N-1:0] b,          // Input operand b (two's complement)
    output wire [N-1:0] c           // Result c = a - b (two's complement)
);

    // Extract sign bits of inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values of a and b
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare magnitudes once and reuse
    wire abs_a_ge_abs_b = (abs_a >= abs_b);

    // Declare wires for magnitude and sign of result
    wire final_sign;
    wire [N-1:0] final_mag;

    // Determine magnitude and sign based on inputs signs and magnitudes
    // Case 1: same sign => subtraction of magnitudes, sign of larger magnitude input
    // Case 2: different sign => addition of magnitudes,
    //         sign depends on relative sizes and sign of a
    assign final_sign = (sign_a == sign_b) ?
                            (abs_a_ge_abs_b ? sign_a : sign_b) :
                            (sign_a ?                          // if a negative
                                (abs_a_ge_abs_b ? 1'b1 : 1'b0) :
                                (abs_a_ge_abs_b ? 1'b0 : 1'b1));

    assign final_mag = (sign_a == sign_b) ?
                            (abs_a_ge_abs_b ? (abs_a - abs_b) : (abs_b - abs_a)) :
                            (abs_a + abs_b);

    // Compose two's complement output from sign and magnitude
    wire [N-1:0] result_tc = final_sign ? (~final_mag + 1'b1) : final_mag;

    // Clear sign bit explicitly when result is zero
    wire is_zero = (final_mag == {N{1'b0}});
    assign c = is_zero ? {N{1'b0}} : result_tc;

endmodule