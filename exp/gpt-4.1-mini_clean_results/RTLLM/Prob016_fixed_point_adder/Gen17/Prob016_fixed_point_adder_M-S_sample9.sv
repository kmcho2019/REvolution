module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (for documentation)
    parameter integer N = 16          // Total width including sign and fractional bits
)(
    input  wire signed [N-1:0] a,    // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,    // Second fixed-point operand (signed two's complement)
    output wire signed [N-1:0] c     // Fixed-point sum result
);

    // Direct signed addition of fixed-point inputs
    assign c = a + b;

endmodule