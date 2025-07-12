module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits (Q16.16 format)
    parameter N = 32    // Total number of bits (32-bit width)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Calculate magnitude result
    wire [N-2:0] mag_result = (a_sign == b_sign) ? 
                            (a_mag - b_mag) :  // Same signs: subtract magnitudes
                            (a_mag + b_mag);  // Different signs: add magnitudes

    // Determine result sign
    wire res_sign;
    assign res_sign = (a_sign == b_sign) ? 
                     a_sign :  // Same signs: result sign matches inputs
                     ((a_mag < b_mag) ? b_sign : a_sign);  // Different signs: compare magnitudes

    // Final result with zero handling
    assign c = (mag_result == {(N-1){1'b0}}) ? {N{1'b0}} : {res_sign, mag_result};

endmodule