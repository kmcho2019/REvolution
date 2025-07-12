module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign and magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Result sign determination
    wire res_sign;
    assign res_sign = (a_sign ^ b_sign) ? 
                     (a_sign ? !a_gt_b : a_gt_b) : 
                     a_sign;

    // Magnitude subtraction
    wire [N-2:0] res_mag;
    assign res_mag = (a_sign == b_sign) ? 
                    (a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag)) :
                    (a_mag + b_mag);

    // Zero detection and final result
    assign c = a_eq_b && (a_sign != b_sign) ? 
               {1'b0, {(N-1){1'b0}}} : 
               {res_sign, res_mag};

endmodule