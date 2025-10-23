module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extend inputs by 1 bit for overflow protection
    wire [N:0] a_ext = {a[N-1], a};
    wire [N:0] b_ext = {b[N-1], b};

    // Perform two's complement subtraction
    wire [N:0] diff = a_ext - b_ext;

    // Determine result components
    wire res_sign = diff[N];
    wire [N-1:0] res_mag = res_sign ? (~diff[N-1:0] + 1'b1) : diff[N-1:0];

    // Zero detection (check all magnitude bits)
    wire is_zero = (res_mag == 0);

    // Final result
    assign c = is_zero ? 0 : {res_sign, res_mag[N-2:0]};

endmodule