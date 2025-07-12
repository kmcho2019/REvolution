module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Continuous assignment with zero handling
    assign c = (a - b == 0) ? {1'b0, {(N-1){1'b0}}} : (a - b);

endmodule