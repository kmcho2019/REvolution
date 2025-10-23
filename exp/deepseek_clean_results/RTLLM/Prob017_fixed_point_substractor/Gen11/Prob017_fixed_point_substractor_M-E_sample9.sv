module fixed_point_subtractor #(
    parameter Q = 16,
    parameter N = 32
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1 : b[N-2:0];
    
    // Comparison and operation selection
    wire a_gt_b = (a_mag > b_mag);
    wire mag_diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    
    // Result sign determination
    wire res_sign = (a_sign & b_sign) ? (a_gt_b ? 1'b1 : 1'b0) :
                   (a_sign & ~b_sign) ? 1'b1 :
                   (~a_sign & b_sign) ? 1'b0 :
                   (a_gt_b ? 1'b0 : 1'b1);
    
    // Zero detection
    wire is_zero = (mag_diff == 0);
    
    // Final result assembly
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : 
               {res_sign, mag_diff[N-2:0]};

endmodule