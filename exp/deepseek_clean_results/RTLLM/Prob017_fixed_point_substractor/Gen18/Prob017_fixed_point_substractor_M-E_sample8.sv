module fixed_point_subtractor #(
    parameter Q = 16,
    parameter N = 32
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Prepare operands with proper sign extension
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] a_adj = a_sign ? ~a + 1 : a;
    wire [N-1:0] b_adj = b_sign ? ~b + 1 : b;

    // Perform unified subtraction
    wire [N:0] raw_diff = {1'b0, a_adj} - {1'b0, b_adj};
    wire diff_sign = raw_diff[N];
    wire [N-1:0] diff_mag = diff_sign ? ~raw_diff[N-1:0] + 1 : raw_diff[N-1:0];

    // Determine final sign
    wire final_sign = (a_sign ^ b_sign) ? 
                     (a_sign ? (|diff_mag ? 1'b1 : 1'b0) : 
                               (|diff_mag ? 1'b0 : 1'b0)) : 
                     a_sign;

    // Handle zero case
    wire is_zero = ~(|diff_mag);

    // Final result assembly
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : {final_sign, diff_mag[N-2:0]};

endmodule