module fixed_point_subtractor #(
    parameter Q = 8,          // Fractional bits
    parameter N = 16          // Total bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,   // Signed fixed-point operand a
    input  wire signed [N-1:0] b,   // Signed fixed-point operand b
    output wire signed [N-1:0] c    // Signed fixed-point subtraction result
);

    // Extract signs directly from signed inputs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values using signed arithmetic
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // Result magnitude and sign wires
    wire [N-1:0] magnitude_sub = (a_ge_b) ? (a_abs - b_abs) : (b_abs - a_abs);
    wire [N-1:0] magnitude_add = a_abs + b_abs;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Calculate intermediate result magnitude depending on sign relation
    wire [N-1:0] res_mag = same_sign ? magnitude_sub : magnitude_add;

    // Determine result sign
    wire res_sign;
    assign res_sign = same_sign
                      ? (a_ge_b ? a_sign : ~a_sign)
                      : ((~a_sign && b_sign) ? (a_ge_b ? 1'b0 : 1'b1)
                                            : (a_ge_b ? 1'b1 : 1'b0));

    // Detect zero magnitude
    wire zero_mag = (res_mag == 0);

    // Compose final result, zero forces sign bit zero explicitly
    assign c = zero_mag
               ? {1'b0, {(N-1){1'b0}}}
               : (res_sign ? (~res_mag + 1'b1) : res_mag);

endmodule