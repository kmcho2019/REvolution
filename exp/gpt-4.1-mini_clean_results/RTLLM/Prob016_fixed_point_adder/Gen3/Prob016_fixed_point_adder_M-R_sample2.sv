module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values of a and b (zero-extend MSB to 0, treating magnitude as unsigned)
    wire [N-1:0] abs_a = {1'b0, a[N-2:0]};
    wire [N-1:0] abs_b = {1'b0, b[N-2:0]};

    // Determine which operand has larger magnitude
    wire a_ge_b = (abs_a >= abs_b);

    // Prepare signed operands for arithmetic
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Compute result according to sign bits
    // If signs are equal, add signed values
    // Else subtract smaller abs from larger abs, sign of result = sign of operand with larger magnitude
    wire signed [N-1:0] sum_same_sign = a_signed + b_signed;

    wire signed [N-1:0] diff_a_b = a_signed - b_signed; // a - b
    wire signed [N-1:0] diff_b_a = b_signed - a_signed; // b - a

    wire signed [N-1:0] result_sub = a_ge_b ? diff_a_b : diff_b_a;

    wire signed [N-1:0] result_raw = (sign_a == sign_b) ? sum_same_sign : result_sub;

    // Force positive zero (sign bit zero) if result is zero
    wire zero_result = (result_raw == 0);
    wire [N-1:0] result_unsigned = zero_result ? {1'b0, {(N-1){1'b0}}} : result_raw[N-1:0];

    assign c = result_unsigned;

endmodule