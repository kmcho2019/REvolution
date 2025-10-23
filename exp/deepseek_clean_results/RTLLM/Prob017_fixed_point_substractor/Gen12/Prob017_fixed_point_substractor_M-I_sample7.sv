module fixed_point_subtractor #(
    parameter N = 32,  // Total number of bits
    parameter Q = 16   // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude representations (two's complement)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];
    
    // Direct subtraction when signs match
    wire [N-1:0] same_sign_sub = {a_sign, a[N-2:0]} - {b_sign, b[N-2:0]};
    
    // Absolute addition when signs differ
    wire [N-1:0] diff_sign_add = {1'b0, a_mag} + {1'b0, b_mag};
    
    // Comparison for sign determination
    wire a_gt_b = (a_mag > b_mag);
    wire is_zero = (a_mag == b_mag);
    
    // Result selection
    wire [N-1:0] result = 
        is_zero ? {1'b0, {N-1{1'b0}}} :  // Handle zero case
        (a_sign == b_sign) ? same_sign_sub :  // Same sign case
        (a_sign ? {a_gt_b, diff_sign_add[N-2:0]} :  // a positive, b negative
                  {~a_gt_b, diff_sign_add[N-2:0]}); // a negative, b positive
    
    assign c = result;

endmodule