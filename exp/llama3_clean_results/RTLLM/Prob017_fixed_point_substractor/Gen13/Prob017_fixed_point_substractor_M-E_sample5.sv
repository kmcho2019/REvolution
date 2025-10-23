module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Separate the integer and fractional parts of a and b
    wire signed [N-Q-1:0] a_int = a >> Q;
    wire signed [Q-1:0] a_frac = a[N-Q-1:0];
    wire signed [N-Q-1:0] b_int = b >> Q;
    wire signed [Q-1:0] b_frac = b[N-Q-1:0];

    // Perform the subtraction for the integer parts
    wire signed [N-Q:0] int_sub = a_int - b_int;

    // Perform the subtraction for the fractional parts
    wire signed [Q:0] frac_sub = {a_frac, 1'b0} - {b_frac, 1'b0};

    // Combine the integer and fractional parts of the result
    wire signed [N:0] result = {int_sub, frac_sub[Q-1:0]};

    // Handle the case where the result is zero
    assign c = (result == 0) ? 0 : result[N-1:0];

endmodule