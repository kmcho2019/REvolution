module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct subtraction handles all cases:
    // - Different signs
    // - Same signs
    // - Zero result
    // - Overflow (wraps around naturally in two's complement)
    assign c = a - b;

endmodule