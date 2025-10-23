module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Cast inputs to signed types for arithmetic and comparisons
    wire signed [N-1:0] a_s = a;
    wire signed [N-1:0] b_s = b;

    // Extract sign bits
    wire a_sign = a_s[N-1];
    wire b_sign = b_s[N-1];

    // Compute absolute values: if negative, two's complement; else unchanged
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Check if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Perform addition of absolute values with one extra bit for overflow detection
    wire [N:0] add_abs_ext = {1'b0, a_abs} + {1'b0, b_abs};

    // For subtraction: always subtract smaller magnitude from larger magnitude
    wire [N-1:0] sub_abs = a_abs_ge_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);

    // Saturation max magnitude value (N bits, sign 0, all ones for magnitude)
    localparam [N-1:0] MAX_MAG = {1'b0, {(N-1){1'b1}}};

    // Determine result magnitude and sign based on input signs
    wire [N-1:0] res_mag = same_sign 
                           ? (add_abs_ext[N] ? MAX_MAG : add_abs_ext[N-1:0]) 
                           : sub_abs;

    wire       res_sign = same_sign 
                          ? a_sign 
                          : (a_abs_ge_b_abs ? a_sign : b_sign);

    // Force positive sign if result magnitude is zero
    wire zero_mag = (res_mag == 0);
    wire final_sign = zero_mag ? 1'b0 : res_sign;

    // Convert magnitude and sign back to two's complement signed number
    wire [N-1:0] res_twos_comp = final_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res_twos_comp;

endmodule