module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire [N-1:0] a,        // Fixed-point input operand A
    input  wire [N-1:0] b,        // Fixed-point input operand B
    output wire [N-1:0] c         // Fixed-point addition result
);

    // Internal signed versions of inputs for arithmetic
    wire signed [N-1:0] signed_a = $signed(a);
    wire signed [N-1:0] signed_b = $signed(b);

    // Perform signed addition
    wire signed [N-1:0] sum = signed_a + signed_b;

    // Assign sum to output
    assign c = sum;

endmodule