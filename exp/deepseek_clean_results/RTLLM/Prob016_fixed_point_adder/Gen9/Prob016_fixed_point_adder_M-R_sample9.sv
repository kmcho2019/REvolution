module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    
    // Magnitude operations
    wire [N-1:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff_mag = (a_mag > b_mag) ? 
                           {1'b0, a_mag - b_mag} : 
                           {1'b0, b_mag - a_mag};
    
    // Sign determination
    wire same_sign = (a_sign == b_sign);
    wire res_sign = same_sign ? a_sign : 
                   (a_mag > b_mag) ? a_sign : b_sign;
    
    // Result selection
    wire [N-1:0] res_mag = same_sign ? sum_mag : diff_mag;
    
    // Overflow detection and result formation
    wire overflow = same_sign & (res_mag[N-1] | (res_mag[N-2:0] == {(N-1){1'b1}}));
    assign c = overflow ? {res_sign, {(N-1){~res_sign}}} : 
               {res_sign, res_mag[N-2:0]};

endmodule