module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total bit width including sign
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point operand a
    input  wire signed [N-1:0] b,  // Signed fixed-point operand b
    output wire signed [N-1:0] c   // Signed fixed-point sum output
);

    // Direct signed addition; synthesis tools optimize correctly.
    assign c = a + b;

endmodule