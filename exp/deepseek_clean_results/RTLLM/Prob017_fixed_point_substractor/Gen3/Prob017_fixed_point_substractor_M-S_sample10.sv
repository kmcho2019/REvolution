module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,  // First operand
    input wire signed [N-1:0] b,  // Second operand
    output wire signed [N-1:0] c  // Result
);

    // Simple signed subtraction handles all cases
    assign c = a - b;

endmodule