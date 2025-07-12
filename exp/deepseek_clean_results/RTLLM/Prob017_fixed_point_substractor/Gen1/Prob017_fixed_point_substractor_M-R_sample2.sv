module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    wire same_sign = (a_sign == b_sign);
    wire diff_sign = ~same_sign;
    
    // Magnitude operations
    wire [N-2:0] mag_sub = a_mag - b_mag;
    wire [N-2:0] mag_add = a_mag + b_mag;
    
    // Result magnitude selection
    wire [N-2:0] res_mag = same_sign ? mag_sub : mag_add;
    
    // Sign determination
    wire res_sign_same = a_sign;  // Same as inputs for same sign case
    wire res_sign_diff = a_sign ? (a_mag > b_mag) : (a_mag < b_mag);
    wire res_sign = same_sign ? res_sign_same : res_sign_diff;
    
    // Final result with zero handling
    assign c = (res_mag == 0) ? {1'b0, {N-1{1'b0}}} : {res_sign, res_mag};

endmodule