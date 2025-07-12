module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed fixed-point numbers (two's complement)
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Compute absolute values inline (two's complement)
    wire [N-1:0] a_abs = (a_signed[N-1]) ? (~a_signed + 1) : a_signed;
    wire [N-1:0] b_abs = (b_signed[N-1]) ? (~b_signed + 1) : b_signed;

    // Check if sign bits are equal
    wire same_sign = (a_signed[N-1] == b_signed[N-1]);

    // Compare absolute values
    wire a_abs_gte_b_abs = (a_abs >= b_abs);

    // Result for same sign: sum directly
    wire signed [N-1:0] sum = a_signed + b_signed;

    // Result for different signs: subtract smaller absolute from larger absolute
    wire [N-1:0] abs_diff = a_abs_gte_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);

    // Determine sign of result when different signs:
    // If abs_diff == 0 => result zero
    // Else sign = sign of operand with larger absolute value
    wire diff_sign = a_abs_gte_b_abs ? a_signed[N-1] : b_signed[N-1];

    // Compose the result for subtraction case
    wire signed [N-1:0] diff_result = (abs_diff == 0) ? {N{1'b0}} :
                                      (diff_sign ? -$signed(abs_diff) : $signed(abs_diff));

    // Final result: select sum if same sign, else diff_result
    wire signed [N-1:0] res = same_sign ? sum : diff_result;

    // Assign output as unsigned wire (fixed-point two's complement)
    assign c = res;

endmodule