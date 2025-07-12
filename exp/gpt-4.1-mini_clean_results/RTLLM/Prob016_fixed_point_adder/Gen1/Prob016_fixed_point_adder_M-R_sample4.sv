module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits
    parameter integer N = 16     // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of two's complement input (N bits)
    // If sign bit is 1, output is two's complement negation, else input itself.
    function [N-1:0] abs_val;
        input [N-1:0] in_val;
        begin
            if (in_val[N-1] == 1'b1)
                abs_val = (~in_val) + 1'b1;
            else
                abs_val = in_val;
        end
    endfunction

    // Calculate absolute values of inputs
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Sum and difference of absolute values
    wire [N:0] abs_sum = {1'b0, a_abs} + {1'b0, b_abs};  // one extra bit for overflow detection
    wire [N-1:0] abs_diff;
    wire       a_abs_ge_b_abs = (a_abs >= b_abs);

    assign abs_diff = a_abs_ge_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);

    // Determine sign and magnitude of result
    wire res_sign;
    wire [N-1:0] res_mag;

    // If signs are same: result sign = input sign, magnitude = abs_sum (with saturation)
    // else: result sign = sign of larger abs input, magnitude = abs_diff
    // Special case: if abs_diff == 0, sign = 0 (positive zero)

    // Saturation for addition overflow:
    // Max magnitude for N bits (excluding sign bit) is 2^(N-1)-1
    localparam [N-1:0] MAX_MAG = {1'b0, {(N-1){1'b1}}};

    wire sum_overflow = abs_sum[N]; // carry out of MSB indicates overflow in magnitude addition

    wire [N-1:0] sum_mag_sat = sum_overflow ? MAX_MAG : abs_sum[N-1:0];

    assign res_sign = (a_sign == b_sign) ? a_sign : (
                        (abs_diff == 0) ? 1'b0 : (a_abs_ge_b_abs ? a_sign : b_sign)
                      );

    assign res_mag = (a_sign == b_sign) ? sum_mag_sat : abs_diff;

    // Compose result in two's complement form: sign and magnitude combined as signed value
    // Since res_mag is magnitude (positive), convert to two's complement if sign=1 (negative)
    wire [N-1:0] res_twos_comp = res_sign ? (~res_mag + 1'b1) : res_mag;

    assign c = res_twos_comp;

endmodule