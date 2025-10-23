module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,    // First operand
    input wire [N-1:0] b,    // Second operand
    output wire [N-1:0] c    // Subtraction result
);

    // Explicit signed intermediate with width casting
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);
    wire signed [N-1:0] result;

    // Perform the subtraction
    assign result = a_signed - b_signed;

    // Output assignment
    assign c = result;

endmodule