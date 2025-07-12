module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits (MSB)
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values of a and b
    // If sign bit is 1, abs = two's complement; else keep original
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_ge_b = (abs_a >= abs_b);

    // Sum and difference of absolute values extended by one bit to avoid overflow on addition
    wire [N:0] abs_sum = {1'b0, abs_a} + {1'b0, abs_b};
    wire [N:0] abs_diff = a_ge_b ? ({1'b0, abs_a} - {1'b0, abs_b})
                                : ({1'b0, abs_b} - {1'b0, abs_a});

    // Determine result sign and magnitude based on input signs
    // Case 1: Same sign => add absolute values, result sign = sign_a (or sign_b)
    // Case 2: Different signs => subtract smaller abs from larger abs
    //   - If a >= b abs: result sign = sign_a
    //   - Else: result sign = sign_b
    wire same_sign = (sign_a == sign_b);

    wire [N-1:0] res_mag = same_sign ? abs_sum[N-1:0] : abs_diff[N-1:0];

    wire res_sign = same_sign ? sign_a : (a_ge_b ? sign_a : sign_b);

    // Compose result: sign bit + magnitude
    // If result magnitude is zero, ensure sign is zero (positive zero)
    wire mag_is_zero = (res_mag == 0);

    wire [N-1:0] res = { (mag_is_zero ? 1'b0 : res_sign), res_mag[N-2:0] };

    // Output assignment
    assign c = res;

endmodule