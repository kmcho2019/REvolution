`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,       // Total bits including sign
    parameter integer Q = 8         // Fractional bits
)(
    input  wire [N-1:0] a,          // Input operand a (two's complement)
    input  wire [N-1:0] b,          // Input operand b (two's complement)
    output wire [N-1:0] c           // Result c = a - b (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values of a and b
    // If negative, take two's complement; if positive, keep as-is
    wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

    // Declare intermediate signals for result magnitude and sign
    wire [N-1:0] mag_sub;      // magnitude from subtraction
    wire [N-1:0] mag_add;      // magnitude from addition
    wire        mag_sub_sign;  // sign of subtraction result (when same sign)
    wire        res_sign;      // final sign of result

    // Subtraction of magnitudes (abs_a - abs_b)
    wire [N-1:0] sub_mag_unsigned;
    wire         sub_mag_sign_bit;
    wire         sub_mag_zero;

    // Use unsigned subtraction with borrow detection:
    // if abs_a >= abs_b, sign is 0 (positive), else sign is 1 (negative)
    wire abs_a_ge_abs_b = (abs_a >= abs_b);
    assign mag_sub = abs_a_ge_abs_b ? (abs_a - abs_b) : (abs_b - abs_a);
    assign mag_sub_sign = (sign_a == sign_b) ? (sign_a) : 1'b0; // placeholder, will override below

    // Addition of magnitudes (abs_a + abs_b)
    assign mag_add = abs_a + abs_b;

    // Determine output sign and magnitude depending on input sign combinations:

    // Case 1: Signs are equal: result = abs(a) - abs(b), sign = sign_a (or sign_b)
    // Case 2: Signs differ:
    //   a positive, b negative => result = abs(a) + abs(b), sign positive (0)
    //   a negative, b positive => result = abs(a) + abs(b), sign negative (1)

    // Additional logic needed when signs differ, to determine sign of final result as per prompt:
    // "If a is positive and b is negative, the absolute values of a and b are added. The result will have a positive sign if a is greater than b, and a negative sign otherwise."
    // Actually, since we are subtracting b from a, the result = a - b, so when b is negative, subtracting negative = addition.
    // But the prompt says result's sign depends on whether a is greater than b or not — so we must clarify this carefully.

    // To reflect this correctly:
    // When signs differ:
    //    If a is positive, b negative => c = a - b = a + |b|
    //      sign is positive (0) if abs_a >= abs_b, else negative (1)
    //    If a negative, b positive => c = a - b = -|a| - b
    //      sign is negative (1) if abs_a + abs_b > 0 (always true if nonzero), but to be consistent:
    //      Compare abs_a and abs_b similarly for sign decision

    // So for different signs:
    //    result magnitude = abs_a + abs_b
    //    sign = sign_a if abs_a >= abs_b, else opposite of sign_a

    // Determine sign for different signs case:
    wire sign_diff_result_sign;
    wire abs_a_ge_abs_b_in_diff = (abs_a >= abs_b);

    assign sign_diff_result_sign = sign_a ? (abs_a_ge_abs_b_in_diff ? 1'b1 : 1'b0)  // a negative: sign_a=1
                                         : (abs_a_ge_abs_b_in_diff ? 1'b0 : 1'b1); // a positive: sign_a=0

    // Final result sign and magnitude selection
    wire final_sign;
    wire [N-1:0] final_mag;

    assign final_sign = (sign_a == sign_b) ?  // same sign: subtraction
                            (abs_a_ge_abs_b ? sign_a : sign_b) : // sign = sign of larger magnitude input
                            sign_diff_result_sign;               // different signs: addition with logic above

    assign final_mag = (sign_a == sign_b) ?
                            (abs_a_ge_abs_b ? (abs_a - abs_b) : (abs_b - abs_a)) : // same sign
                            (abs_a + abs_b);                                       // different signs

    // Convert final sign + magnitude back to two's complement output
    wire [N-1:0] result_unsigned = final_sign ? (~final_mag + 1) : final_mag;

    // Handle zero explicitly by clearing sign bit if magnitude is zero
    wire is_zero = (final_mag == 0);
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} : result_unsigned;

endmodule