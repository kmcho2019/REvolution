module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits (precision), default 8
    parameter integer N = 16         // Total number of bits including sign, default 16
)(
    input  wire [N-1:0] a,           // Fixed-point input operand A
    input  wire [N-1:0] b,           // Fixed-point input operand B
    output wire [N-1:0] c            // Fixed-point addition result
);

    // Internal signals for absolute values and sign bits
    reg [N-1:0] abs_a, abs_b;
    reg sign_a, sign_b;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg [N-1:0] res;
    reg res_sign;

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Compute absolute values of a and b
        abs_a = sign_a ? (~a + 1'b1) : a;
        abs_b = sign_b ? (~b + 1'b1) : b;

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;
            res_sign = sign_a;

            // Convert sum_abs back to signed result
            if (res_sign) begin
                // Negative result: two's complement of magnitude
                res = (~sum_abs + 1'b1);
            end else begin
                // Positive result: direct magnitude
                res = sum_abs;
            end
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a == abs_b) begin
                // Result is zero if absolute values equal
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
                diff_abs = abs_b - abs_a;
                res_sign = sign_b;
                if (res_sign) begin
                    res = (~diff_abs + 1'b1);
                end else begin
                    res = diff_abs;
                end
            end
        end
    end

    assign c = res;

endmodule