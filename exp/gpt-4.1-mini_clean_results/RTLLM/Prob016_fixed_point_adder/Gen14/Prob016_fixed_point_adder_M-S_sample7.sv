module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire signed [N-1:0] a,     // First N-bit fixed-point operand
    input  wire signed [N-1:0] b,     // Second N-bit fixed-point operand
    output wire signed [N-1:0] c      // N-bit fixed-point addition result
);

    // Direct signed addition handles fixed-point addition correctly
    assign c = a + b;

endmodule