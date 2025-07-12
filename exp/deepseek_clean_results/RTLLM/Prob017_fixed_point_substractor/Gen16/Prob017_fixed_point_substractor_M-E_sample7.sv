module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
    // output wire overflow  // Optional overflow flag
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine operation mode
    wire op_mode = (a_sign == b_sign) ? 1'b1 : 1'b0;  // 1 for subtract, 0 for add

    // Perform magnitude operation
    wire [N-1:0] mag_result;
    assign mag_result = op_mode ? 
                       ({1'b0, a_mag} - {1'b0, b_mag}) : 
                       ({1'b0, a_mag} + {1'b0, b_mag});

    // Determine result sign
    wire res_sign;
    assign res_sign = (op_mode) ? a_sign :  // Same sign case keeps input sign
                     (a_sign ? (a_mag > b_mag) : (b_mag > a_mag));

    // Zero detection and correction
    wire is_zero = (mag_result[N-2:0] == 0);
    wire final_sign = is_zero ? 1'b0 : res_sign;

    // Optional overflow detection
    // assign overflow = (mag_result[N-1] != 1'b0) && !is_zero;

    // Final result assembly
    assign c = {final_sign, mag_result[N-2:0]};

endmodule