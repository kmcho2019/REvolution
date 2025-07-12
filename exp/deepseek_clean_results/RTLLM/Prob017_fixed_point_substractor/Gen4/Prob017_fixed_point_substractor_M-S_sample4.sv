module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits (unused in core logic)
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

// Continuous assignment for simplest implementation
assign c = a - b;

endmodule