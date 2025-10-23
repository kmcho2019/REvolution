module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);

    // Magnitude operations
    wire [N-2:0] sub_mag = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    wire [N-2:0] add_mag = a_mag + b_mag;

    // Result selection
    wire [N-2:0] res_mag = (a_sign == b_sign) ? sub_mag : add_mag;
    wire res_sign = (a_sign == b_sign) ? (a_gt_b ? a_sign : ~a_sign) : a_sign;

    // Zero detection and final result
    wire is_zero = (res_mag == {(N-1){1'b0}});
    wire final_sign = is_zero ? 1'b0 : res_sign;
    wire [N-2:0] final_mag = is_zero ? {(N-1){1'b0}} : res_mag;

    // Output assignment with explicit width handling
    assign c = {final_sign, final_sign ? (~final_mag + 1'b1) : final_mag};

endmodule