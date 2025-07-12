module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire [N-1:0] a,         // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c          // Fixed-point addition result (two's complement)
);

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Convert two's complement inputs to magnitude: if negative, mag = -value; else mag = value
    wire [N-2:0] mag_a = sign_a ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] mag_b = sign_b ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Compare magnitudes
    wire mag_a_gt_b = (mag_a > mag_b);
    wire mag_a_eq_b = (mag_a == mag_b);

    // Add magnitudes (extended by 1 bit to hold carry)
    wire [N-1:0] mag_sum = {1'b0, mag_a} + {1'b0, mag_b};

    // Subtract magnitudes (extended by 1 bit)
    wire [N-1:0] mag_diff_a_b = {1'b0, mag_a} - {1'b0, mag_b};
    wire [N-1:0] mag_diff_b_a = {1'b0, mag_b} - {1'b0, mag_a};

    // Result sign and magnitude wires
    wire res_sign_add = sign_a; // when signs equal, result sign = sign_a (== sign_b)
    wire [N-1:0] res_mag_add = mag_sum;

    wire res_sign_sub = mag_a_gt_b ? sign_a :
                        (mag_a_eq_b ? 1'b0 : sign_b); // if equal magnitude, sign=0 (positive zero)
    wire [N-1:0] res_mag_sub = mag_a_gt_b ? mag_diff_a_b :
                              (mag_a_eq_b ? {N{1'b0}} : mag_diff_b_a);

    // Select addition or subtraction result based on sign equality
    wire signs_equal = (sign_a == sign_b);

    // Final magnitude and sign before conversion back to two's complement
    wire [N-1:0] res_mag_pre = signs_equal ? res_mag_add : res_mag_sub;
    wire        res_sign_pre = signs_equal ? res_sign_add : res_sign_sub;

    // Convert sign and magnitude back to two's complement fixed-point
    wire [N-1:0] res_twos_comp = res_sign_pre ? {1'b1, (~res_mag_pre[N-2:0] + 1'b1)} : {1'b0, res_mag_pre[N-2:0]};

    // Internal register for the result, updated combinationally
    always @(*) begin
        c = res_twos_comp;
    end

endmodule