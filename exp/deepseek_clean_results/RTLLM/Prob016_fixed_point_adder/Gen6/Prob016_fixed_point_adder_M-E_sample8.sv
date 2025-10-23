module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Operation determination
    wire do_add = ~(a_sign ^ b_sign);
    wire res_sign = do_add ? a_sign : 
                   (a_mag > b_mag) ? a_sign : b_sign;

    // Extended precision magnitude calculation
    wire [N-1:0] ext_a_mag = {1'b0, a_mag};
    wire [N-1:0] ext_b_mag = {1'b0, b_mag};
    
    wire [N-1:0] mag_result = do_add ? (ext_a_mag + ext_b_mag) :
                           (a_mag > b_mag) ? (ext_a_mag - ext_b_mag) :
                           (ext_b_mag - ext_a_mag);

    // Overflow detection and normalization
    wire overflow = mag_result[N-1];
    wire [N-2:0] norm_mag = overflow ? {(N-1){1'b1}} : 
                            (mag_result == 0) ? 0 : 
                            mag_result[N-2:0];

    // Zero result special case
    wire is_zero = (mag_result == 0);
    wire final_sign = is_zero ? 1'b0 : res_sign;

    // Final result assembly
    assign c = {final_sign, norm_mag};

endmodule