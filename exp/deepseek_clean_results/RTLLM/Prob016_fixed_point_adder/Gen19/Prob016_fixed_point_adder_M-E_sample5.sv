module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using generate
    generate
        if (Q >= N) begin
            // This will cause elaboration error if Q >= N
            illegal_parameter_combination illegal();
        end
    endgenerate

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison (parallel)
    wire a_mag_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);

    // Operation control signals
    wire same_sign = (a_sign == b_sign);
    wire do_sub = ~same_sign;
    wire do_add = same_sign;

    // Carry-save addition for magnitude
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff = a_mag_gt_b ? {1'b0, a_mag - b_mag} : {1'b0, b_mag - a_mag};

    // Result magnitude selection
    wire [N-1:0] res_mag = do_add ? sum : diff;

    // Result sign determination
    wire res_sign;
    assign res_sign = (do_add) ? a_sign :               // Addition keeps sign
                     (mag_equal) ? 1'b0 :               // a-b=0 is positive
                     (a_mag_gt_b) ? a_sign : b_sign;    // Subtraction takes sign of larger

    // Overflow detection (only possible in addition)
    wire overflow = do_add & res_mag[N-1];

    // Final result construction with saturation
    assign c = overflow ? {a_sign, {(N-1){~a_sign}}} :  // Saturate to max/min
               {res_sign, res_mag[N-2:0]};             // Normal result

endmodule