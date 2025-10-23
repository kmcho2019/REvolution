module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation (Q cannot exceed N)
    localparam VALID_Q = (Q <= N) ? Q : N;

    // Direct two's complement subtraction
    wire [N-1:0] subtraction_result = a - b;

    // Optimized zero detection
    wire is_zero = ~(|subtraction_result);

    // Final result with forced positive zero
    assign c = is_zero ? {N{1'b0}} : subtraction_result;

endmodule