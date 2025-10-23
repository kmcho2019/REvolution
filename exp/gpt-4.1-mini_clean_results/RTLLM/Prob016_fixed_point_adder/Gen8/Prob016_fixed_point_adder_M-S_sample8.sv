module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire [N-1:0] a,         // Fixed-point input operand A
    input  wire [N-1:0] b,         // Fixed-point input operand B
    output wire [N-1:0] c          // Fixed-point addition result
);

    // Use signed types for arithmetic
    wire signed [N-1:0] signed_a = a;
    wire signed [N-1:0] signed_b = b;
    wire signed [N:0]   signed_sum;  // One extra bit to catch overflow if needed

    assign signed_sum = signed_a + signed_b;
    assign c = signed_sum[N-1:0];    // Truncate to N bits, preserving fixed-point format

endmodule