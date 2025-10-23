module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits (default 16)
    parameter N = 32     // Total number of bits (default 32)
) (
    input wire signed [N-1:0] a,  // First fixed-point operand (signed)
    input wire signed [N-1:0] b,  // Second fixed-point operand (signed)
    output wire signed [N-1:0] c  // Fixed-point result (a - b, signed)
);

    // Signed subtraction automatically handles:
    // - Same sign: Direct subtraction of magnitudes
    // - Different signs: Equivalent to addition of absolute values
    // - Zero result: Proper sign handling (always positive 0)
    // - Overflow: Wraps according to 2's complement rules
    assign c = a - b;

endmodule