module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison using subtraction
    wire [N-2:0] mag_diff = a_mag - b_mag;
    wire a_gt_b = ~mag_diff[N-2];  // MSB indicates borrow

    // Magnitude operations
    wire [N-1:0] mag_sum = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] mag_diff_result = a_gt_b ? {1'b0, mag_diff} : {1'b0, b_mag - a_mag};

    // Sign and operation control
    wire same_sign = ~(a_sign ^ b_sign);
    wire res_sign = same_sign ? a_sign : (a_gt_b ? a_sign : b_sign);

    // Result selection and overflow detection
    wire [N-1:0] unsigned_res = same_sign ? mag_sum : mag_diff_result;
    assign overflow = same_sign & mag_sum[N-1];

    // Final output assignment
    assign c = {res_sign, unsigned_res[N-2:0]};

endmodule