module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total bit width
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow,
    output wire underflow
);

    localparam INT_BITS = N - Q - 1;  // Integer bits (excluding sign)

    // Extract sign and magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Determine operation type and result sign
    wire op_add = a_sign ^ b_sign;  // Different signs = addition
    wire res_sign;
    wire a_gt_b = (a_mag > b_mag);

    assign res_sign = (op_add) ? 
                     (a_sign & ~b_sign ? 1'b1 : 1'b0) :  // Different signs: result sign follows a
                     (a_sign ? (a_gt_b ? 1'b1 : 1'b0) :  // Both negative: sign depends on magnitude
                               (a_gt_b ? 1'b0 : 1'b1));   // Both positive: sign depends on magnitude

    // Perform magnitude operation
    wire [N-1:0] mag_result;
    wire [N-1:0] mag_a = {1'b0, a_mag};
    wire [N-1:0] mag_b = {1'b0, b_mag};

    assign mag_result = op_add ? 
                      (mag_a + mag_b) :  // Different signs: add magnitudes
                      (a_gt_b ? (mag_a - mag_b) : (mag_b - mag_a));  // Same signs: subtract smaller from larger

    // Detect overflow/underflow
    assign overflow = op_add & mag_result[N-1];  // Addition overflow
    assign underflow = ~op_add & ~a_gt_b & (a_mag != b_mag);  // Subtraction underflow (negative result when a < b)

    // Final result assembly
    assign c = (a_mag == b_mag && ~op_add) ? {1'b0, {N-1{1'b0}}} :  // Force positive zero
               {res_sign, mag_result[N-2:0]};

endmodule