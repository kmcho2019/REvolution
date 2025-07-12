module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits including sign
)(
    input  wire signed [N-1:0] a,  // Signed fixed-point input operand A
    input  wire signed [N-1:0] b,  // Signed fixed-point input operand B
    output wire signed [N-1:0] c   // Signed fixed-point result
);

    // Perform addition using signed arithmetic with extended bit width
    wire signed [N:0] sum_ext;
    assign sum_ext = $signed(a) + $signed(b);

    // Truncate the result to N bits (dropping the overflow bit if any)
    assign c = sum_ext[N-1:0];

endmodule