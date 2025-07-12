module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total number of bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,            // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Declare signed versions of inputs for signed arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Intermediate signed addition result with extra bit for overflow detection
    wire signed [N:0] sum_ext;  // N+1 bits to detect overflow beyond N bits

    // Internal signals for decision
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Extract absolute values as unsigned for magnitude comparison
    wire [N-1:0] a_abs = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = sign_b ? (~b + 1'b1) : b;

    wire a_abs_ge_b_abs = (a_abs >= b_abs);

    reg signed [N-1:0] res;
    reg res_sign;

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: add directly
            res = a_signed + b_signed;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_abs_ge_b_abs) begin
                // Result sign = sign of a
                res_sign = sign_a;
                // res = abs(a) - abs(b) with sign
                res = res_sign ? -($signed(a_abs) - $signed(b_abs)) : ($signed(a_abs) - $signed(b_abs));
            end else begin
                // Result sign = sign of b
                res_sign = sign_b;
                // res = abs(b) - abs(a) with sign
                res = res_sign ? -($signed(b_abs) - $signed(a_abs)) : ($signed(b_abs) - $signed(a_abs));
            end
        end

        // Handle the case where signs match and addition might overflow:
        // Truncate result to N bits by slicing.
        // Two's complement signed addition will naturally wrap around; no extra overflow flag per spec.

        // For zero result, force sign to zero (positive zero)
        if (res == 0)
            c = {N{1'b0}};
        else
            c = res[N-1:0];
    end

endmodule