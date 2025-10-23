module fixed_point_subtractor #(
    parameter Q = 16,    // Fractional bits
    parameter N = 32     // Total bits
) (
    input wire signed [N-1:0] a,    // First operand
    input wire signed [N-1:0] b,    // Second operand
    output wire signed [N-1:0] c    // Subtraction result
);

    // Direct signed subtraction handles all cases
    assign c = a - b;

endmodule