module fixed_point_adder #(
    parameter integer Q = 8,   // Number of fractional bits
    parameter integer N = 16   // Total bits (including sign bit)
)(
    input  wire [N-1:0] a,    // Fixed-point input operand a
    input  wire [N-1:0] b,    // Fixed-point input operand b
    output wire [N-1:0] c     // Fixed-point addition result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitude (absolute value) of a
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;

    // Compute magnitude (absolute value) of b
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Same sign addition: sum magnitudes with carry-out
    wire [N:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};

    // Magnitude difference and sign when signs differ
    wire a_greater = (a_mag > b_mag);
    wire magnitudes_equal = (a_mag == b_mag);

    wire [N-1:0] diff_mag = a_greater ? (a_mag - b_mag) : (b_mag - a_mag);

    // Determine result sign and magnitude based on sign bits
    wire res_sign;
    wire [N-1:0] res_mag;

    assign {res_sign, res_mag} = (a_sign == b_sign) ? 
                                 {a_sign, sum_mag[N-1:0]} :                 // Same sign: add magnitudes, sign same
                                 (magnitudes_equal ? {1'b0, {N{1'b0}}} :     // Different signs & equal magnitude: zero
                                    a_greater ? {a_sign, diff_mag} :         // a_mag > b_mag: sign of a
                                                {b_sign, diff_mag});         // b_mag > a_mag: sign of b

    // Convert signed magnitude back to two's complement fixed-point number
    // If negative sign, invert magnitude and add one; else keep magnitude as is
    assign c = res_sign ? (~res_mag + 1'b1) : res_mag;

endmodule