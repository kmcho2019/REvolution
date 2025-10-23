module fixed_point_subtractor #(
    parameter N = 32,  // Total number of bits
    parameter Q = 16   // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    localparam M = N-1;  // Magnitude bits

    // Sign and magnitude extraction
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [M-1:0] a_mag = a_sign ? -a[M-1:0] : a[M-1:0];
    wire [M-1:0] b_mag = b_sign ? -b[M-1:0] : b[M-1:0];

    // Arithmetic operation and comparison
    wire [M-1:0] mag_diff = a_mag - b_mag;
    wire is_zero = (a_mag == b_mag);
    wire a_larger = (mag_diff[M-1] == 0) && !is_zero;

    // Sign determination
    wire result_sign = is_zero ? 1'b0 : 
                     (a_sign == b_sign) ? (a_sign ^ !a_larger) : 
                     a_sign;

    // Result magnitude
    wire [M-1:0] result_mag = is_zero ? {M{1'b0}} :
                             a_larger ? mag_diff :
                             -mag_diff;

    // Final output
    assign c = {result_sign, result_mag};

endmodule