module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits (precision)
    parameter integer N = 16         // Total number of bits including sign
)(
    input  wire [N-1:0] a,           // Fixed-point input operand A
    input  wire [N-1:0] b,           // Fixed-point input operand B
    output reg  [N-1:0] c            // Fixed-point addition result
);

    // Internal registers for absolute values and sign bits
    reg [N-1:0] abs_a, abs_b;
    reg sign_a, sign_b;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg [N-1:0] res;
    reg res_sign;

    // Compute sign bits
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values of a and b
        abs_a = sign_a ? (~a + 1'b1) : a;
        abs_b = sign_b ? (~b + 1'b1) : b;

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;
            // Limit sum_abs width to N bits (wraparound on overflow)
            // Determine result sign (same as inputs)
            res_sign = sign_a;

            // Assign result: sign bit + magnitude
            // Convert sum_abs back to two's complement with sign
            if (res_sign) begin
                // Negative: two's complement of sum_abs
                res = (~sum_abs + 1'b1);
            end else begin
                // Positive: sum_abs as is
                res = sum_abs;
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a == abs_b) begin
                // Result zero if absolute values equal
                res = {N{1'b0}};
            end else if (abs_a > abs_b) begin
                diff_abs = abs_a - abs_b;
                res_sign = sign_a;
                if (res_sign) begin
                    res = (~diff_abs + 1'b1);
                end else begin
                    res = diff_abs;
                end
            end else begin
                // abs_b > abs_a
                diff_abs = abs_b - abs_a;
                res_sign = sign_b;
                if (res_sign) begin
                    res = (~diff_abs + 1'b1);
                end else begin
                    res = diff_abs;
                end
            end
        end

        c = res;
    end

endmodule