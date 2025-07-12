module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude parts (N-1 bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Full precision addition/subtraction results
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff_ab = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-1:0] diff_ba = {1'b0, b_mag} - {1'b0, a_mag};
    
    // Overflow detection
    wire sum_overflow = sum[N-1];
    wire diff_overflow = (a_sign != b_sign) && 
                       ((a_mag > b_mag) ? diff_ab[N-1] : diff_ba[N-1]);
    
    // Result selection
    assign c = (a_sign == b_sign) ? 
               (sum_overflow ? {a_sign, {(N-1){~a_sign}}} : {a_sign, sum[N-2:0]}) :
               (a_mag > b_mag) ? 
                   (diff_overflow ? {1'b0, {(N-1){1'b1}}} : {a_sign, diff_ab[N-2:0]}) :
                   (diff_overflow ? {1'b1, {(N-1){1'b0}}} : {b_sign, diff_ba[N-2:0]});

endmodule