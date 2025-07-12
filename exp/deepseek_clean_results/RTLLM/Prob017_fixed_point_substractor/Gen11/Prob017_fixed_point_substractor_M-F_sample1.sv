module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform subtraction (handles all sign cases automatically)
    wire [N-1:0] raw_diff = a - b;

    // Simplified zero detection
    wire is_zero = ~(|raw_diff[N-2:0]);

    // Final output with zero handling
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : raw_diff;

endmodule