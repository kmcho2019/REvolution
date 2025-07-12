module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Hybrid representation conversion
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-1:0] a_mag = a_sign ? ~a + 1 : a;
    wire [N-1:0] b_mag = b_sign ? ~b + 1 : b;

    // Operation type detection
    wire op_add = ~(a_sign ^ b_sign);
    wire op_sub = a_sign ^ b_sign;

    // Parallel magnitude comparison (MSB first)
    wire b_gt_a;
    generate
        if (N > 1) begin
            assign b_gt_a = (b_mag > a_mag);
        end else begin
            assign b_gt_a = b_mag[0] & ~a_mag[0];
        end
    endgenerate

    // Dual-path arithmetic
    wire [N:0] sum_path = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N:0] diff_path = b_gt_a ? {1'b0, b_mag} - {1'b0, a_mag} 
                          : {1'b0, a_mag} - {1'b0, b_mag};

    // Result selection and sign determination
    wire [N:0] arith_res = op_add ? sum_path : diff_path;
    wire res_sign = op_add ? a_sign : (b_gt_a ? b_sign : a_sign);

    // Overflow prediction (carry into sign bit)
    assign overflow = op_add & (sum_path[N] ^ sum_path[N-1]);

    // Result formatting with proper sign
    wire [N-1:0] unsigned_res = arith_res[N-1:0];
    assign c = res_sign ? ~unsigned_res + 1 : unsigned_res;

    // Integrated rounding (optional)
    // wire round_bit = unsigned_res[Q-1];
    // assign c = res_sign ? ~(unsigned_res[N-1:Q] + round_bit) + 1 
    //           : unsigned_res[N-1:Q] + round_bit;

endmodule