module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Combined magnitude operation
    wire [N-2:0] mag_result = (a_sign ^ b_sign) ? 
                             (a_mag + b_mag) :  // Different signs: add magnitudes
                             (a_mag - b_mag);   // Same signs: subtract magnitudes
    
    // Simplified sign determination
    wire res_sign = (a_sign ^ b_sign) ? 
                   (a_sign ? (a_mag > b_mag) : (a_mag < b_mag)) :
                   a_sign;
    
    // Zero detection and result formation
    wire is_zero = ~(|mag_result);  // Bitwise OR for zero detection
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : {res_sign, mag_result};

endmodule