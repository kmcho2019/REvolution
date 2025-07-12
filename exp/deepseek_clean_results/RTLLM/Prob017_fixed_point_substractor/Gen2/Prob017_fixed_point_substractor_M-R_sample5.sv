module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Determine if signs are same or different
    wire same_sign = ~(a_sign ^ b_sign);
    
    // Calculate magnitude operations
    wire [N-2:0] mag_sub = a_mag - b_mag;
    wire [N-2:0] mag_add = a_mag + b_mag;
    
    // Select appropriate magnitude based on sign condition
    wire [N-2:0] res_mag = same_sign ? mag_sub : mag_add;
    
    // Determine result sign
    wire res_sign = same_sign ? 
                   a_sign :                     // Same sign case
                   (a_sign ?                    // Different signs case
                       (a_mag > b_mag) :       // a negative, b positive
                       (a_mag < b_mag));        // a positive, b negative
    
    // Handle zero result explicitly
    assign c = (res_mag == 0) ? {1'b0, {N-1{1'b0}}} : {res_sign, res_mag};

endmodule