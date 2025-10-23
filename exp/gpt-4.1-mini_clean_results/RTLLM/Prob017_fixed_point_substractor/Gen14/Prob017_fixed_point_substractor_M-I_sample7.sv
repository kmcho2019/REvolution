module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign)
    parameter integer Q = 8    // Fractional bits (unused in logic but for user reference)
)(
    input  wire [N-1:0] a,     // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,     // Fixed-point operand b (two's complement)
    output wire [N-1:0] c      // Result of a - b (two's complement)
);

    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform subtraction
    wire signed [N-1:0] diff = a_signed - b_signed;

    // If diff is zero, force sign bit to 0, else assign diff directly
    assign c = (diff == 0) ? {1'b0, {(N-1){1'b0}}} : diff;

endmodule