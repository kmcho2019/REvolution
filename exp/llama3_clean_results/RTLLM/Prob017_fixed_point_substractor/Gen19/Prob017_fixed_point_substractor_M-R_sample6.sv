module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Directly calculate the result using assign statements
assign c = (a > b)? (a - b) : (b > a)? -(b - a) : 0;

// The above statement handles all cases, including when a and b are equal (result is 0),
// and when a or b is negative, ensuring the correct sign for the result.

endmodule