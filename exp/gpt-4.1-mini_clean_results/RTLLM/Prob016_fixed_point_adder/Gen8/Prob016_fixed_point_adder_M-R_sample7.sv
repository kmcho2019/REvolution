module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);
    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Calculate magnitudes (absolute values) by conditional two's complement
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Add magnitudes if same sign (result may be N bits wide)
    wire [N-1:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Compare magnitudes for subtraction when signs differ
    wire a_greater = (mag_a > mag_b);
    wire b_greater = (mag_b > mag_a);
    wire equal_mag = (mag_a == mag_b);

    // Result magnitude and sign wires
    wire [N-2:0] result_mag_add = mag_sum[N-2:0]; // truncate MSB for addition
    wire [N-2:0] result_mag_sub = a_greater ? (mag_a - mag_b) : (mag_b - mag_a);
    wire result_sign_add = sign_a;                // sign when adding magnitudes (same sign)
    wire result_sign_sub = a_greater ? sign_a : sign_b;

    // Determine final sign and magnitude based on input signs
    wire [N-2:0] result_mag = (sign_a == sign_b) ? result_mag_add :
                              (equal_mag ? {(N-1){1'b0}} : result_mag_sub);

    wire result_sign = (sign_a == sign_b) ? result_sign_add :
                       (equal_mag ? 1'b0 : result_sign_sub);

    // Zero result magnitude forces sign to zero (positive zero)
    wire zero_result = (result_mag == {(N-1){1'b0}});
    wire final_sign = zero_result ? 1'b0 : result_sign;

    // Assemble output
    assign c = {final_sign, result_mag};

endmodule