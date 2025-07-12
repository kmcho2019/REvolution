module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    generate
        if (Q >= N) begin
            initial $error("Fractional bits Q must be less than total bits N");
        end
    endgenerate

    // Early zero detection
    wire is_zero = (a == b);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire sign_diff = a_sign ^ b_sign;

    // Magnitude calculations (conditional inversion)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Magnitude comparison and difference
    wire a_gt_b = (a_mag > b_mag);
    wire [N-2:0] mag_diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);

    // Result sign determination
    wire result_sign = 
        is_zero ? 1'b0 :                    // Zero case
        (~sign_diff) ? a_sign :             // Same signs
        (a_sign ? ~a_gt_b : a_gt_b);        // Different signs

    // Final result assembly
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} :
              {result_sign, mag_diff};

endmodule