module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Direct two's complement addition of fixed-point numbers
    // The output is truncated to N bits naturally
    assign c = a + b;

endmodule