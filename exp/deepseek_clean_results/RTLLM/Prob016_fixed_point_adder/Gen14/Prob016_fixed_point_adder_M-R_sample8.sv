module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using generate
    generate
        if (Q >= N) begin
            invalid_parameter_q_too_large invalid();
        end
        if (N < 2) begin
            invalid_parameter_n_too_small invalid();
        end
    endgenerate

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison (used for both sign and arithmetic)
    wire a_gt_b = (a_mag > b_mag);
    wire signs_equal = ~(a_sign ^ b_sign);

    // Arithmetic units (parallel implementation for better timing)
    wire [N-1:0] sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] diff_ab = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-1:0] diff_ba = {1'b0, b_mag} - {1'b0, a_mag};

    // Result selection
    wire [N-1:0] arith_result = signs_equal ? sum : 
                               (a_gt_b ? diff_ab : diff_ba);

    // Sign determination (parallel with arithmetic)
    wire result_sign = signs_equal ? a_sign : 
                     (a_gt_b ? a_sign : b_sign);

    // Overflow detection (only possible when adding same signs)
    wire overflow = signs_equal & sum[N-1];

    // Saturation values
    wire [N-1:0] max_positive = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_negative = {1'b1, {(N-1){1'b0}}};

    // Final result with overflow handling
    assign c = overflow ? (result_sign ? max_negative : max_positive) :
               {result_sign, arith_result[N-2:0]};

endmodule