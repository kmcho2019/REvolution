module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
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

    // Extract sign and magnitude components
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine magnitude relationship and zero condition
    wire a_gt_b = (a_mag > b_mag);
    wire mag_equal = (a_mag == b_mag);
    wire is_zero = mag_equal && (a_sign != b_sign);

    // Compute result sign
    wire result_sign = (is_zero) ? 1'b0 :  // Force positive zero
                      (a_sign == b_sign) ? a_sign :
                      a_gt_b ? a_sign : b_sign;

    // Single magnitude operation unit
    wire [N-2:0] mag_result;
    assign mag_result = (a_sign == b_sign) ? (a_mag + b_mag) :
                       a_gt_b ? (a_mag - b_mag) :
                       (b_mag - a_mag);

    // Combine sign and magnitude
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} :  // Explicit zero handling
               {result_sign, mag_result};

endmodule