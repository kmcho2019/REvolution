module fixed_point_adder #(
    // Number of fractional bits (precision)
    parameter integer Q = 8,
    // Total number of bits (including sign and fractional)
    parameter integer N = 16
) (
    input  wire signed [N-1:0] a,  // First operand: signed fixed-point two's complement
    input  wire signed [N-1:0] b,  // Second operand: signed fixed-point two's complement
    output wire signed [N-1:0] c   // Result: signed fixed-point two's complement
);

    // Simple signed addition for fixed-point numbers
    // Both a and b are in two's complement fixed-point with Q fractional bits.
    // Addition naturally preserves fixed-point alignment.
    assign c = a + b;

endmodule