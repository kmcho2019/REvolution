module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Calculate the integer and fractional parts of the inputs
wire signed [N-1:0] a_int = a >>> Q;
wire signed [N-1:0] b_int = b >>> Q;
wire signed [Q-1:0] a_frac = a % (1 << Q);
wire signed [Q-1:0] b_frac = b % (1 << Q);

// Perform the subtraction operation
wire signed [N-1:0] int_result = a_int - b_int;
wire signed [Q-1:0] frac_result = a_frac - b_frac;

// Handle the case where the result is zero
assign c = (int_result == 0 && frac_result == 0) ? 0 : (int_result << Q) + frac_result;

endmodule