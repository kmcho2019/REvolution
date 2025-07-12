module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

// Continuous assignment handles all cases:
// - Same sign subtraction
// - Different sign addition
// - Zero result
// - Proper sign handling
assign c = a - b;

endmodule