module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c  // Fixed-point result
);

    // Simple signed subtraction handles all cases including zero
    assign c = a - b;

endmodule