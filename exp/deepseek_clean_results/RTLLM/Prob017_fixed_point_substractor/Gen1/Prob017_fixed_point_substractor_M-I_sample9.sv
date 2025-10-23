module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    wire same_sign;
    wire a_is_neg;
    wire b_is_neg;
    wire signed [N-1:0] diff;
    wire signed [N-1:0] sum_abs;
    wire result_is_zero;

    // Sign detection
    assign a_is_neg = a[N-1];
    assign b_is_neg = b[N-1];
    assign same_sign = (a_is_neg == b_is_neg);

    // Arithmetic operations
    assign diff = a - b;
    assign sum_abs = (a_is_neg ? -a : a) + (b_is_neg ? -b : b);
    assign result_is_zero = (diff == 0);

    always @(*) begin
        if (same_sign) begin
            // Same sign case - direct subtraction
            c = diff;
        end else begin
            // Different signs case
            if (a_is_neg) begin
                // a negative, b positive: result is -(abs(a) + abs(b))
                c = -sum_abs;
            end else begin
                // a positive, b negative: result is (abs(a) + abs(b))
                c = sum_abs;
            end
        end

        // Explicit zero handling (overrides previous assignments)
        if (result_is_zero) begin
            c = 0;
        end
    end

endmodule