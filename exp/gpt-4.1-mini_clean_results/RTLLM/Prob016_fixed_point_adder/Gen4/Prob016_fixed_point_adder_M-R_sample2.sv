module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Compute absolute values using conditional expressions
    wire [N-1:0] a_abs = (a_signed < 0) ? (~a_signed + 1'b1) : a_signed;
    wire [N-1:0] b_abs = (b_signed < 0) ? (~b_signed + 1'b1) : b_signed;

    // Determine if signs are same
    wire same_sign = (a[N-1] == b[N-1]);

    // Calculate result when signs are same (sum) or different (difference)
    wire signed [N-1:0] sum = a_signed + b_signed;

    // Determine which absolute value is larger and corresponding sign
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Absolute difference
    wire [N-1:0] abs_diff = a_abs_ge_b_abs ? (a_abs - b_abs) : (b_abs - a_abs);

    // Sign of result when signs differ, based on operand with larger magnitude
    wire diff_sign = a_abs_ge_b_abs ? a[N-1] : b[N-1];

    // Signed result for difference case:
    // - zero if abs_diff==0
    // - negative if diff_sign == 1, positive otherwise
    wire signed [N-1:0] diff_result =
        (abs_diff == 0) ? {N{1'b0}} :
        (diff_sign == 1'b1) ? -$signed(abs_diff) :
                             $signed(abs_diff);

    // Final result assigned based on sign comparison
    wire signed [N-1:0] res = same_sign ? sum : diff_result;

    // Output assignment
    assign c = res;

endmodule