module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
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

    // Determine operation type and result sign
    wire same_sign = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    
    // Calculate magnitude result
    wire [N-1:0] mag_result;
    assign mag_result[N-2:0] = same_sign ? (a_mag + b_mag) : 
                              (a_larger ? (a_mag - b_mag) : (b_mag - a_mag));
    assign mag_result[N-1] = 1'b0; // Magnitude is always positive

    // Detect overflow (only possible when adding same signs)
    wire overflow = same_sign & (mag_result[N-1] | (a_mag[N-2] & b_mag[N-2] & ~mag_result[N-2]));

    // Determine final sign (account for zero result)
    wire result_sign = same_sign ? a_sign : 
                      (a_mag == b_mag) ? 1'b0 : 
                      (a_larger ? a_sign : b_sign);

    // Saturated result
    wire [N-1:0] saturated = result_sign ? {1'b1, {(N-1){1'b0}}} :  // Most negative
                            {1'b0, {(N-1){1'b1}}};                  // Most positive

    // Final output
    assign c = overflow ? saturated : 
               (a_mag == b_mag && !same_sign) ? {N{1'b0}} :  // Handle zero case
               {result_sign, mag_result[N-2:0]};

endmodule