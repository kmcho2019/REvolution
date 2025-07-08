module fixed_point_adder #(
    parameter Q = 8,            // Number of fractional bits
    parameter N = 16            // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for the result
    reg [N-1:0] res;

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values of a and b (N bits)
    // For two's complement, absolute value can be obtained by:
    // if sign=1 -> negate, else unchanged
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Comparison of absolute values
    wire a_gt_b = (abs_a > abs_b);

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add absolute values, result sign same as inputs
            // Add absolute values, may have carry out but result is truncated to N bits
            reg [N:0] sum_ext;
            sum_ext = {1'b0, abs_a} + {1'b0, abs_b};
            // Assign result: sign bit same as inputs
            res = {sign_a, sum_ext[N-2:0]};
            // Overflow may happen but is ignored, as result truncated
        end else begin
            // Different signs: subtract smaller absolute value from larger
            if (a_gt_b) begin
                // res = abs_a - abs_b, sign = sign of a (sign_a)
                res = (sign_a ? (~(abs_a - abs_b) + 1'b1) : (abs_a - abs_b));
            end else if (abs_b > abs_a) begin
                // res = abs_b - abs_a, sign = sign of b (sign_b)
                res = (sign_b ? (~(abs_b - abs_a) + 1'b1) : (abs_b - abs_a));
            end else begin
                // abs_a == abs_b -> result zero
                res = {N{1'b0}};
            end
        end

        c = res;
    end

endmodule