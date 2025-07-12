module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Calculate absolute values
    wire [N-1:0] a_abs = a[N-1] ? -a : a;
    wire [N-1:0] b_abs = b[N-1] ? -b : b;
    
    // Extract signs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Calculate magnitude differences
    wire [N-1:0] mag_diff_ab = a_abs - b_abs;
    wire [N-1:0] mag_diff_ba = b_abs - a_abs;
    
    // Determine result components
    wire same_sign = (a_sign == b_sign);
    wire a_larger = (a_abs > b_abs);
    
    // Calculate intermediate result
    wire [N-1:0] result_mag = same_sign ? 
                             (a_larger ? mag_diff_ab : mag_diff_ba) : 
                             (a_abs + b_abs);
    
    wire result_sign = same_sign ? 
                      (a_larger ? a_sign : ~a_sign) : 
                      a_sign;
    
    // Final result with zero detection
    assign c = (result_mag[N-2:0] == 0) ? 
               {1'b0, result_mag[N-2:0]} : 
               {result_sign, result_mag[N-2:0]};

endmodule