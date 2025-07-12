module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign and fraction
)(
    input  wire signed [N-1:0] a,    // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,    // Second fixed-point operand (signed two's complement)
    output wire signed [N-1:0] c     // Fixed-point sum result
);

    // Fixed-point addition via signed arithmetic
    assign c = a + b;

endmodule