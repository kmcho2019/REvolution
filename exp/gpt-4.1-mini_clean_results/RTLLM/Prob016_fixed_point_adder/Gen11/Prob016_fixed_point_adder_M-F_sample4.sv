module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,        // First fixed-point operand
    input  wire [N-1:0] b,        // Second fixed-point operand
    output wire [N-1:0] c         // Result of fixed-point addition
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values without function
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    // Extended width signals for add/subtract to detect overflow if needed
    wire [N:0] abs_add = {1'b0, a_abs} + {1'b0, b_abs};
    wire [N:0] abs_sub_a_b = {1'b0, a_abs} - {1'b0, b_abs};
    wire [N:0] abs_sub_b_a = {1'b0, b_abs} - {1'b0, a_abs};

    // Case 1: Signs are equal -> sum absolute values, sign same as inputs
    wire [N-1:0] sum_val = abs_add[N-1:0];
    wire sum_sign = a_sign;

    // Case 2a: Signs differ, a_abs >= b_abs -> subtract b_abs from a_abs, sign positive if result non-zero
    wire [N-1:0] diff_ab = abs_sub_a_b[N-1:0];
    wire diff_ab_zero = (diff_ab == 0);

    // Case 2b: Signs differ, b_abs > a_abs -> subtract a_abs from b_abs, sign = b_sign if result non-zero
    wire [N-1:0] diff_ba = abs_sub_b_a[N-1:0];
    wire diff_ba_zero = (diff_ba == 0);

    // Compose result based on cases
    reg [N-1:0] res;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: sum absolute values, sign same as inputs
            res = {sum_sign, sum_val[N-2:0]};
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs_ge_b_abs) begin
                // a_abs >= b_abs: result positive if diff != 0, else zero
                if (diff_ab_zero) begin
                    res = {N{1'b0}};  // zero
                end else begin
                    res = {1'b0, diff_ab[N-2:0]};  // positive result
                end
            end else begin
                // b_abs > a_abs: sign is b_sign if diff != 0, else zero
                if (diff_ba_zero) begin
                    res = {N{1'b0}};  // zero
                end else begin
                    res = {b_sign, diff_ba[N-2:0]};
                end
            end
        end
    end

    assign c = res;

endmodule