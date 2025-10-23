module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire signed [N-1:0] a,     // Signed fixed-point input operand A
    input  wire signed [N-1:0] b,     // Signed fixed-point input operand B
    output wire signed [N-1:0] c      // Signed fixed-point addition result
);

    // Perform signed fixed-point addition directly
    assign c = a + b;

endmodule