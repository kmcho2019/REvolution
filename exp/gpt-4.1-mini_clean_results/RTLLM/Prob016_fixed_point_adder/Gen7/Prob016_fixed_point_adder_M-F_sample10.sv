module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A
    input  wire [N-1:0] b,        // Fixed-point input operand B
    output wire [N-1:0] c         // Fixed-point addition result
);

    // Perform fixed-point addition with two's complement arithmetic
    // The binary point position is at Q fractional bits from LSB.
    // Overflow naturally wraps around, consistent with fixed-point behavior.
    assign c = a + b;

endmodule