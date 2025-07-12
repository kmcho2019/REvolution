module fixed_point_adder #(
    parameter integer N = 16,   // Total number of bits (including sign)
    parameter integer Q = 8     // Fractional bits (interface parameter)
)(
    input  wire [N-1:0] a,      // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand b (two's complement)
    output wire [N-1:0] c       // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // When signs are equal, add directly
    // When signs differ, subtract smaller magnitude from larger magnitude and set sign accordingly

    // Compute absolute values
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes
    wire a_ge_b = (a_abs >= b_abs);

    // Result magnitude
    wire [N-1:0] mag_sum = a_abs + b_abs;
    wire [N-1:0] mag_diff = a_ge_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Result sign
    wire res_sign;
    wire [N-1:0] res_mag;
    assign res_sign = (a_sign == b_sign) ? a_sign :
                      (a_ge_b ? a_sign : b_sign);

    assign res_mag = (a_sign == b_sign) ? mag_sum : mag_diff;

    // Convert magnitude and sign back to two's complement
    wire [N-1:0] res = res_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res;

endmodule