module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    
    // Absolute values (magnitude without sign)
    wire [N-2:0] abs_a = sign_a ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] abs_b = sign_b ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Sign comparison
    wire same_sign = ~(sign_a ^ sign_b);
    
    // Magnitude comparison
    wire a_gt_b = (abs_a > abs_b);
    
    // Operation selection
    wire [N-2:0] sum_mag = abs_a + abs_b;
    wire [N-2:0] diff_mag = a_gt_b ? (abs_a - abs_b) : (abs_b - abs_a);
    
    // Result magnitude and sign
    wire [N-2:0] res_mag = same_sign ? sum_mag : diff_mag;
    wire res_sign = same_sign ? sign_a : 
                   (a_gt_b ? sign_a : sign_b);
    
    // Overflow detection (only possible when adding same signs)
    wire overflow = same_sign & sum_mag[N-2];
    
    // Final result with overflow handling
    assign c = overflow ? 
               {res_sign, {(N-1){~res_sign}}} :  // Saturate to max/min
               {res_sign, res_mag};

endmodule