module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign bits and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] a_mag = {1'b0, a[N-2:0]};
    wire [N-1:0] b_mag = {1'b0, b[N-2:0]};

    // Sign comparison and operation selection
    wire signs_equal = ~(a_sign ^ b_sign);
    wire a_gt_b = (a_sign == b_sign) ? (a_mag > b_mag) : ~a_sign;

    // Shared adder for both sum and difference
    wire [N-1:0] sum = a_mag + b_mag;
    wire [N-1:0] diff = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);

    // Result selection and sign determination
    wire [N-1:0] abs_res = signs_equal ? sum : diff;
    wire res_sign = signs_equal ? a_sign : (a_gt_b ? a_sign : b_sign);

    // Overflow detection (only possible when signs equal)
    wire overflow = signs_equal & sum[N-1];

    // Final result with saturation
    assign c = overflow ? {res_sign, {N-1{~res_sign}}} : 
              {res_sign, abs_res[N-2:0]};

endmodule