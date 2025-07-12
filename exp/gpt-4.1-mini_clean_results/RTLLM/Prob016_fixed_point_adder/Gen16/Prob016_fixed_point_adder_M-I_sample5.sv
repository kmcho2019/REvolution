module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits (precision)
    parameter integer N = 16           // Total number of bits including sign
)(
    input  wire signed [N-1:0] a,      // Fixed-point input operand A (two's complement signed)
    input  wire signed [N-1:0] b,      // Fixed-point input operand B (two's complement signed)
    output wire signed [N-1:0] c       // Fixed-point addition result (two's complement signed)
);

    // Direct signed addition of fixed-point operands
    wire signed [N:0] sum_ext;         // One extra bit to hold carry/overflow temporarily

    assign sum_ext = a + b;

    // Result truncated to N bits; overflow bits discarded (wraparound)
    assign c = sum_ext[N-1:0];

endmodule