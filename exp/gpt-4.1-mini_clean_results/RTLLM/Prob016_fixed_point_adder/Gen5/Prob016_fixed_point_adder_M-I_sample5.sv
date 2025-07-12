module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values (magnitude) of inputs
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    wire same_sign = (a_sign == b_sign);

    // Intermediate signals for result magnitude and sign
    wire [N-1:0] sum_abs;
    wire [N-1:0] diff_abs;
    wire a_gte_b = (a_abs >= b_abs);

    assign sum_abs = a_abs + b_abs;
    assign diff_abs = a_gte_b ? (a_abs - b_abs) : (b_abs - a_abs);

    // Determine result sign:
    // If signs equal, result sign same as inputs.
    // Else, sign is sign of larger magnitude operand.
    // If result magnitude zero, force positive sign.
    wire res_sign_pre = same_sign ? a_sign : (a_gte_b ? a_sign : b_sign);
    wire res_sign = (diff_abs == 0) ? 1'b0 : res_sign_pre;

    // Select result magnitude:
    // sum_abs if same sign addition, diff_abs if subtraction
    wire [N-1:0] res_mag = same_sign ? sum_abs : diff_abs;

    // Convert sign/magnitude to two's complement:
    // If sign=1 (negative), output is two's complement of magnitude
    // else output is magnitude as is.
    assign c = res_sign ? (~res_mag + 1'b1) : res_mag;

endmodule