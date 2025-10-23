module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (default matches Q16.16 format)
    parameter N = 32    // Total number of bits (default 32-bit width)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude parts
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Magnitude result (handles both same and different sign cases)
    wire [N-2:0] mag_result = (a_sign == b_sign) ? 
                            (a_mag - b_mag) :  // Same signs: subtract
                            (a_mag + b_mag);   // Different signs: add
    
    // Result sign determination
    wire res_sign = (a_sign == b_sign) ? 
                   a_sign :  // Same signs: result sign matches inputs
                   ((a_sign && (a_mag > b_mag)) || (!a_sign && (a_mag < b_mag)));
    
    // Final result with zero handling
    assign c = (mag_result == 0) ? 0 : {res_sign, mag_result};

endmodule