module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Cast inputs to signed types for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Perform signed subtraction
    wire signed [N-1:0] diff = a_signed - b_signed;

    // Handle zero-result sign bit explicitly
    // If diff is zero, force the sign bit (MSB) to zero
    assign c = (diff == {N{1'b0}}) ? {1'b0, {(N-1){1'b0}}} : diff;

endmodule