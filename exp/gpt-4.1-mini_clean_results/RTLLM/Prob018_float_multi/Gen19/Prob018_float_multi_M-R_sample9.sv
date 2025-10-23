module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Stage 1 registers: extracted inputs and special flags
    reg         a_sign_s1, b_sign_s1;
    reg  [7:0]  a_exp_s1, b_exp_s1;
    reg  [22:0] a_frac_s1, b_frac_s1;
    reg         a_zero_s1, b_zero_s1;
    reg         a_inf_s1, b_inf_s1;
    reg         a_nan_s1, b_nan_s1;
    reg  [23:0] a_mant_s1, b_mant_s1; // mantissa with implicit 1 or 0

    // Stage 2 registers: multiplication result and exponent sum
    reg  [47:0] product_s2;
    reg  [9:0]  exp_sum_s2;
    reg         sign_s2;
    reg         special_nan_s2;
    reg         special_nan_out_s2;
    reg         special_inf_s2;
    reg         special_zero_s2;

    // Stage 3 registers: normalized product, exponent, rounding and final mantissa/exponent
    reg  [47:0] norm_product_s3;
    reg  [9:0]  norm_exp_s3;
    reg  [23:0] mantissa_s3;
    reg         guard_bit_s3;
    reg         round_bit_s3;
    reg         sticky_bit_s3;
    reg         round_increment_s3;
    reg  [24:0] mant_rounded_s3;
    reg  [23:0] mant_rounded_final_s3;
    reg  [9:0]  exp_rounded_s3;
    reg         sign_s3;

    // Stage 1: Combinational special-case detection functions
    function automatic is_zero(input [7:0] exp, input [22:0] frac);
        is_zero = (exp == 8'd0) && (frac == 23'd0);
    endfunction

    function automatic is_inf(input [7:0] exp, input [22:0] frac);
        is_inf = (exp == 8'hFF) && (frac == 23'd0);
    endfunction

    function automatic is_nan(input [7:0] exp, input [22:0] frac);
        is_nan = (exp == 8'hFF) && (frac != 23'd0);
    endfunction

    // Stage 1: Extract input fields and detect special cases (combinational)
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w  = is_inf(a[30:23], a[22:0]);
    wire b_inf_w  = is_inf(b[30:23], b[22:0]);
    wire a_nan_w  = is_nan(a[30:23], a[22:0]);
    wire b_nan_w  = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Stage 2: Multiply mantissas and add exponents (combinational)
    wire [47:0] product_w = a_mant_s1 * b_mant_s1;
    wire [9:0] exp_sum_w = a_exp_s1 + b_exp_s1 - EXP_BIAS;
    wire sign_w = a_sign_s1 ^ b_sign_s1;

    // Stage 2: Special case outputs (combinational)
    wire special_nan_w = a_nan_s1 || b_nan_s1;
    wire special_nan_out_w = (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
    wire special_inf_w = (a_inf_s1 || b_inf_s1) && !special_nan_out_w;
    wire special_zero_w = (a_zero_s1 || b_zero_s1) && !special_nan_out_w && !special_inf_w;

    // Stage 3: Normalization and rounding (combinational)
    wire [47:0] norm_product_w = product_w[47] ? (product_w >> 1) : product_w;
    wire [9:0] norm_exp_w = product_w[47] ? (exp_sum_w + 10'd1) : exp_sum_w;

    wire [23:0] mantissa_w = norm_product_w[46:23];
    wire guard_bit_w = norm_product_w[23];
    wire round_bit_w = norm_product_w[22];
    wire sticky_bit_w = |norm_product_w[21:0];

    wire round_increment_w = guard_bit_w && (round_bit_w || sticky_bit_w || mantissa_w[0]);

    wire [24:0] mant_rounded_w = {1'b0, mantissa_w} + round_increment_w;

    wire mantissa_overflow = mant_rounded_w[24];
    wire [23:0] mant_rounded_final_w = mantissa_overflow ? mant_rounded_w[24:1] : mant_rounded_w[23:0];
    wire [9:0] exp_rounded_w = mantissa_overflow ? (norm_exp_w + 10'd1) : norm_exp_w;

    // Sequential pipeline registers updating each clock cycle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all pipeline registers and output
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;

            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            mantissa_s3 <= 24'd0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            round_increment_s3 <= 1'b0;
            mant_rounded_s3 <= 25'd0;
            mant_rounded_final_s3 <= 24'd0;
            exp_rounded_s3 <= 10'd0;
            sign_s3 <= 1'b0;

            z <= 32'd0;
        end else begin
            // Stage 1 registers - latch inputs and special flags
            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exp_s1 <= a[30:23];
            b_exp_s1 <= b[30:23];
            a_frac_s1 <= a[22:0];
            b_frac_s1 <= b[22:0];
            a_zero_s1 <= a_zero_w;
            b_zero_s1 <= b_zero_w;
            a_inf_s1 <= a_inf_w;
            b_inf_s1 <= b_inf_w;
            a_nan_s1 <= a_nan_w;
            b_nan_s1 <= b_nan_w;
            a_mant_s1 <= a_mant_w;
            b_mant_s1 <= b_mant_w;

            // Stage 2 registers - latch multiplication and exponent sums
            product_s2 <= product_w;
            exp_sum_s2 <= exp_sum_w;
            sign_s2 <= sign_w;
            special_nan_s2 <= special_nan_w;
            special_nan_out_s2 <= special_nan_out_w;
            special_inf_s2 <= special_inf_w;
            special_zero_s2 <= special_zero_w;

            // Stage 3 registers - latch normalization and rounding values
            norm_product_s3 <= norm_product_w;
            norm_exp_s3 <= norm_exp_w;
            mantissa_s3 <= mantissa_w;
            guard_bit_s3 <= guard_bit_w;
            round_bit_s3 <= round_bit_w;
            sticky_bit_s3 <= sticky_bit_w;
            round_increment_s3 <= round_increment_w;
            mant_rounded_s3 <= mant_rounded_w;
            mant_rounded_final_s3 <= mant_rounded_final_w;
            exp_rounded_s3 <= exp_rounded_w;
            sign_s3 <= sign_s2;

            // Output stage - produce final IEEE754 result considering special cases
            if (special_nan_s2) begin
                // Quiet NaN (canonical): sign=0, exp=255, MSB mantissa=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s2) begin
                // NaN result from Inf*0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                // Infinity with sign
                z <= {sign_s2, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                // Zero with sign
                z <= {sign_s2, 31'd0};
            end else if (exp_rounded_s3[9:8] != 2'b00) begin
                // Overflow exponent → Infinity
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3 == 10'd0) begin
                // Underflow exponent → Zero (no subnormal support)
                z <= {sign_s3, 31'd0};
            end else begin
                // Normal number output
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule