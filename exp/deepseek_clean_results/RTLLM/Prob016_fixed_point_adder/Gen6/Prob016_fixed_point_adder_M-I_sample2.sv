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
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Result calculation
    wire [N-2:0] res_mag;
    wire res_sign;
    
    assign {res_sign, res_mag} = 
        (a_sign == b_sign) ? 
            {a_sign, a_mag + b_mag} :  // Same signs: add magnitudes
        a_gt_b ? 
            {a_sign, a_mag - b_mag} :  // Different signs, |a| > |b|
            {b_sign, b_mag - a_mag};   // Different signs, |b| > |a|
    
    // Final output (implicit overflow handling by truncation)
    assign c = {res_sign, res_mag};

endmodule