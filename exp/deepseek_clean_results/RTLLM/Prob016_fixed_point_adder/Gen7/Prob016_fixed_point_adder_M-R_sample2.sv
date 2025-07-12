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
    
    // Magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    
    // Operation determination
    wire do_add = (a_sign == b_sign);
    
    // Unified arithmetic processing
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire a_gt_b = (a_mag > b_mag);
    wire [N-2:0] diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
    
    // Result construction
    wire res_sign = do_add ? a_sign : 
                   (a_gt_b ? a_sign : b_sign);
    wire [N-2:0] res_mag = do_add ? sum[N-2:0] : diff;
    
    // Overflow detection
    wire ovf = do_add ? sum[N-1] : 1'b0;
    wire res_zero = (res_mag == 0);
    
    // Final output with saturation
    assign c = ovf ? {res_sign, {(N-1){1'b1}}} : 
              res_zero ? {N{1'b0}} : 
              {res_sign, res_mag};

endmodule