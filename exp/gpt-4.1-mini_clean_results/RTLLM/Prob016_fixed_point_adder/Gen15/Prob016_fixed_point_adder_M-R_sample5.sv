module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign and fractional bits
)(
    input  wire [N-1:0] a,        // First fixed-point input operand (two's complement)
    input  wire [N-1:0] b,        // Second fixed-point input operand (two's complement)
    output wire [N-1:0] c         // Fixed-point addition result (two's complement)
);

    // Interpret inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform signed addition directly
    wire signed [N:0] sum_extended = a_signed + b_signed; 
    // Extend by one bit to capture overflow if needed

    // Assign lower N bits as result (two's complement wrapping)
    assign c = sum_extended[N-1:0];

endmodule

/*
Explanation:
- Inputs and output are fixed-point signed numbers in two's complement.
- Adding two signed numbers includes both absolute value addition and subtraction behavior inherently.
- No explicit magnitude extraction or sign checks needed.
- Overflow wraps naturally in two's complement arithmetic.
- Parameter Q defines fractional bits but does not affect addition logic.
*/