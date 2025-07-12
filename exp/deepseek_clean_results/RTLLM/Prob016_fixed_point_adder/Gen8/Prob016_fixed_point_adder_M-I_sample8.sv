module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Same sign case: direct addition
    wire same_sign = ~(a_sign ^ b_sign);
    wire [N-1:0] sum = {a_sign, a_mag} + {b_sign, b_mag};
    
    // Different sign case: subtraction
    wire a_gt_b = (a_mag > b_mag);
    wire [N-2:0] diff_mag = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = a_gt_b ? a_sign : b_sign;
    wire [N-1:0] diff = {diff_sign, diff_mag};
    
    // Result selection
    assign c = same_sign ? sum : diff;

    // Overflow detection (optional output could be added)
    // wire overflow = same_sign & (sum[N-1] != a_sign);

endmodule