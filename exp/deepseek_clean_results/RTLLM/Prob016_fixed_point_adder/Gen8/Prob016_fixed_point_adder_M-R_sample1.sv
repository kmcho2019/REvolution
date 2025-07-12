module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits and magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Absolute values (magnitudes)
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    
    // For same sign addition
    wire [N-1:0] raw_sum = a + b;
    wire sum_overflow = signs_equal & (raw_sum[N-1] != a_sign);
    
    // For different sign subtraction
    wire a_larger = (a_mag > b_mag);
    wire [N-2:0] abs_diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);
    wire diff_sign = (a_mag == b_mag) ? 1'b0 : (a_larger ? a_sign : b_sign);
    
    // Saturation values
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}}};
    
    // Result selection
    assign c = signs_equal ? 
               (sum_overflow ? (a_sign ? max_neg : max_pos) : raw_sum) :
               {diff_sign, abs_diff};

endmodule