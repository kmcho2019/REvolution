module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c  // Subtraction result
);

    // Core subtraction operation with automatic sign handling
    assign c = a - b;

endmodule