module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Sign bits of inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute magnitudes of inputs
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Comparison to determine magnitude ordering
    wire a_ge_b = (mag_a >= mag_b);

    // Sum of magnitudes when signs are equal
    wire [N-1:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Single difference: larger magnitude minus smaller magnitude
    wire [N-1:0] mag_diff = a_ge_b ? 
                           ({1'b0, mag_a} - {1'b0, mag_b}) :
                           ({1'b0, mag_b} - {1'b0, mag_a});

    // Determine if input signs are equal
    wire signs_equal = (sign_a == sign_b);

    // Determine result magnitude and sign based on signs_equal and magnitude comparison
    wire [N-2:0] res_mag = signs_equal ? mag_sum[N-2:0] : mag_diff[N-2:0];

    // Determine result sign
    // For same sign: result sign = input sign
    // For different sign: sign of larger magnitude operand
    wire res_sign = signs_equal ? sign_a : (a_ge_b ? sign_a : sign_b);

    // If result magnitude is zero, force sign to positive (0)
    wire zero_mag = (res_mag == {(N-1){1'b0}});
    wire final_sign = zero_mag ? 1'b0 : res_sign;

    // Construct two's complement result from sign and magnitude
    assign c = final_sign ? {1'b1, (~res_mag + 1'b1)} : {1'b0, res_mag};

endmodule