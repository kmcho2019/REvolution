module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c   // Subtraction result
);

    // Perform subtraction and handle zero case in one expression
    assign c = (a - b == 0) ? {1'b0, {(N-1){1'b0}}} : (a - b);

endmodule