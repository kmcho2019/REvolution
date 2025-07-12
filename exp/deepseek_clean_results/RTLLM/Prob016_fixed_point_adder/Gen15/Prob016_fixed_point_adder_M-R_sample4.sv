module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
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

    // Calculate sum and difference of magnitudes
    wire [N-1:0] sum_mag = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff_mag = (a_mag > b_mag) ? 
                           {1'b0, a_mag - b_mag} : 
                           {1'b0, b_mag - a_mag};

    // Determine operation based on signs
    wire do_add = (a_sign == b_sign);
    wire res_sign = do_add ? a_sign : 
                   (a_mag > b_mag) ? a_sign : b_sign;

    // Select appropriate result magnitude
    wire [N-1:0] res_mag = do_add ? sum_mag : diff_mag;

    // Detect overflow (carry out for addition)
    wire overflow = do_add & sum_mag[N-1];

    // Build final result with saturation
    assign c = overflow ? 
              {a_sign, {(N-1){~a_sign}}} :  // Saturate to max/min
              {res_sign, res_mag[N-2:0]};    // Normal result

endmodule