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
    
    // Magnitudes (N-1 bits to drop sign)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Determine operation and result sign
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_gt_b = (a_mag > b_mag);
    
    // Absolute value operations
    wire [N-1:0] abs_sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] abs_diff = a_gt_b ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};
    
    // Result sign logic
    wire res_sign = signs_equal ? a_sign : 
                  (a_gt_b ? a_sign : b_sign);
    
    // Final result assembly
    wire [N-1:0] res = signs_equal ? {res_sign, abs_sum[N-2:0]} : 
                      {res_sign, abs_diff[N-2:0]};
    
    // Overflow detection (when signs equal but result sign differs)
    wire overflow = signs_equal & (a_sign ^ abs_sum[N-1]);
    
    // Handle overflow by saturating
    assign c = overflow ? {res_sign, {N-1{~res_sign}}} : res;

endmodule