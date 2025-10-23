module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Local parameters for consistency
    localparam INT_BITS = N - Q;
    localparam MAG_BITS = N - 1;

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [MAG_BITS-1:0] a_mag = a[MAG_BITS-1:0];
    wire [MAG_BITS-1:0] b_mag = b[MAG_BITS-1:0];

    // Perform magnitude operation based on signs
    wire [MAG_BITS:0] mag_result;
    assign mag_result = (a_sign == b_sign) ? 
                       ({1'b0, a_mag} - {1'b0, b_mag}) : 
                       ({1'b0, a_mag} + {1'b0, b_mag});

    // Determine result sign
    wire res_sign;
    assign res_sign = (a_sign == b_sign) ? a_sign :  // Same sign case
                     (a_sign ? (a_mag > b_mag) : (b_mag > a_mag));

    // Zero detection and correction
    wire is_zero = (mag_result[MAG_BITS-1:0] == 0);
    wire final_sign = is_zero ? 1'b0 : res_sign;

    // Final result assembly
    assign c = {final_sign, mag_result[MAG_BITS-1:0]};

endmodule