module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits (for documentation clarity, not directly used in this implementation)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Perform subtraction directly using continuous assignment
// The built-in signed arithmetic in Verilog handles signs and magnitudes correctly.
assign c = a - b;

endmodule