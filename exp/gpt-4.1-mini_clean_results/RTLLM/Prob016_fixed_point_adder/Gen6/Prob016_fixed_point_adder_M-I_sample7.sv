module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A
    input  wire [N-1:0] b,        // Fixed-point input operand B
    output wire [N-1:0] c         // Fixed-point addition result
);

    // Direct two's complement addition of fixed-point numbers
    // Inputs and output have the same fixed Q fractional bits.
    // Overflow naturally wraps around in two's complement arithmetic,
    // consistent with fixed-point addition.

    assign c = a + b;

endmodule