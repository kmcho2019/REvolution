module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output wire [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Cast inputs to signed for arithmetic
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Perform addition with an extra bit to detect overflow (optional)
    wire signed [N:0] sum_extended = a_signed + b_signed;

    // Assign result truncated back to N bits
    assign c = sum_extended[N-1:0];

endmodule