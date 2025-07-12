module fixed_point_subtractor #(
    parameter N = 32,  // Total number of bits
    parameter Q = 16   // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Magnitude comparison and subtraction
    wire a_larger = (a_mag > b_mag);
    wire magnitudes_equal = (a_mag == b_mag);
    wire [N-2:0] mag_diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);

    // Sign determination using continuous assignments
    wire same_sign = (a_sign == b_sign);
    wire result_sign = magnitudes_equal ? 1'b0 : 
                      (same_sign ? a_sign : 
                      (a_sign ? !a_larger : a_larger));

    // Result assembly
    wire [N-1:0] result = {result_sign, mag_diff};
    assign c = magnitudes_equal ? {1'b0, {N-1{1'b0}}} : result;

endmodule