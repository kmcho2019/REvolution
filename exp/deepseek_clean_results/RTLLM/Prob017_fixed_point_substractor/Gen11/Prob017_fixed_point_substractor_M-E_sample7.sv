module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Convert inputs to sign-magnitude format
    wire a_sign = a[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire a_zero = ~(|a[N-1:0]);

    wire b_sign = b[N-1];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];
    wire b_zero = ~(|b[N-1:0]);

    // Determine if we need to invert b for subtraction
    wire invert_b = ~b_sign;
    wire [N-2:0] b_operand = invert_b ? -b_mag : b_mag;

    // Perform the addition (which handles both addition and subtraction)
    wire [N-1:0] raw_sum = {1'b0, a_mag} + {1'b0, b_operand};
    wire sum_zero = ~(|raw_sum);

    // Determine the result sign
    wire result_sign;
    assign result_sign = sum_zero ? 1'b0 : 
                       (a_zero ? b_sign : 
                       (b_zero ? a_sign : 
                       (a_sign ^ (a_mag < b_mag))));

    // Handle overflow and construct final result
    wire [N-2:0] result_mag = sum_zero ? {N-1{1'b0}} : 
                             (a_sign ^ result_sign) ? -raw_sum[N-2:0] : raw_sum[N-2:0];

    assign c = {result_sign, result_mag};

endmodule