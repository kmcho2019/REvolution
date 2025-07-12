module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Sign prediction logic
    wire res_sign;
    assign res_sign = (a_sign & ~b_sign) ? 1'b1 :  // -a - +b = -(a + b)
                    (~a_sign & b_sign) ? 1'b0 :    // +a - -b = +(a + b)
                    (a_sign & b_sign) ? (a_gt_b ? 1'b1 : 1'b0) :  // -a - -b
                    (a_gt_b ? 1'b0 : 1'b1);        // +a - +b

    // Dual-path subtraction
    wire [N-1:0] pos_sub = a_mag - b_mag;  // Positive magnitude subtractor
    wire [N-1:0] neg_sub = b_mag - a_mag;  // Negative magnitude subtractor

    // Magnitude selection
    wire [N-2:0] res_mag;
    assign res_mag = (a_sign == b_sign) ? 
                    (a_gt_b ? pos_sub[N-2:0] : neg_sub[N-2:0]) :
                    (a_mag + b_mag);  // Different signs: add magnitudes

    // Zero detection
    wire is_zero = a_eq_b & (a_sign == b_sign);

    // Final result assembly
    assign c = is_zero ? {N{1'b0}} : {res_sign, res_mag};

endmodule