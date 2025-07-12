module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform subtraction with overflow protection
    wire [N:0] diff = {a[N-1], a} - {b[N-1], b};

    // Extract components
    wire res_sign = diff[N];
    wire [N-1:0] res_mag = diff[N-1:0];

    // Zero detection - check all bits except sign
    wire is_zero = (res_mag == 0);

    // Final result construction
    assign c = is_zero ? {N{1'b0}} : {res_sign, res_mag[N-2:0]};

endmodule