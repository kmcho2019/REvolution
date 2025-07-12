module fixed_point_adder #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total number of bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Direct signed addition handles fixed-point sum correctly
    assign c = a + b;

endmodule