module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // --- Stage 1 registers: input extraction and special cases ---
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1,  b_exp_s1;
    reg  [22:0]  a_frac_s1, b_frac_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;

    // --- Stage 2 registers: multiply mantissas, sum exponents, sign, special case flags ---
    reg  [47:0]  product_s2;
    reg  [9:0]   exp_sum_s2;   // 10 bits for exponent addition with bias subtraction and increment
    reg          sign_s2;

    // Propagated special cases flags:
    reg          special_nan_s2;
    reg          special_inf_s2;
    reg          special_zero_s2;
    reg          special_nan_out_s2; // Inf*Zero => NaN

    // --- Stage 3 registers: normalization, rounding, final mantissa, exponent, and output sign ---
    reg  [47:0]  norm_product_s3;
    reg  [9:0]   norm_exp_s3;
    reg          guard_bit_s3;
    reg          round_bit_s3;
    reg          sticky_bit_s3;
    reg  [23:0]  mantissa_s3;

    reg          round_increment_s3;
    reg  [24:0]  mant_rounded_s3;
    reg  [23:0]  mant_rounded_final_s3;
    reg  [9:0]   exp_rounded_s3;
    reg          sign_s3;

    // Helper functions for special case detection
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Combinational wires for stage 1
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w  = is_inf(a[30:23], a[22:0]);
    wire b_inf_w  = is_inf(b[30:23], b[22:0]);
    wire a_nan_w  = is_nan(a[30:23], a[22:0]);
    wire b_nan_w  = is_nan(b[30:23], b[22:0]);

    // Prepare mantissas with hidden leading 1 for normalized numbers, else zero
    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all pipeline registers and output
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0;  b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;

            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            mantissa_s3 <= 24'd0;

            round_increment_s3 <= 1'b0;
            mant_rounded_s3 <= 25'd0;
            mant_rounded_final_s3 <= 24'd0;
            exp_rounded_s3 <= 10'd0;
            sign_s3 <= 1'b0;

            z <= 32'd0;
        end else begin
            // -------- Stage 1: Extract inputs and detect special cases --------
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

            // -------- Stage 2: Multiply mantissas, sum exponents, XOR signs, set special flags --------
            product_s2 <= a_mant_s1 * b_mant_s1;
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2 && !special_nan_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2 && !special_nan_s2;

            // -------- Stage 3: Normalize product, generate rounding bits, round, adjust exponent --------
            // Normalization: if product MSB (bit 47) is 1, shift right one and increment exponent
            if (product_s2[47]) begin
                norm_product_s3 <= product_s2 >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= product_s2;
                norm_exp_s3 <= exp_sum_s2;
            end

            // Mantissa bits for output: bits [46:23] (24 bits)
            mantissa_s3 <= norm_product_s3[46:23];

            // Rounding bits: guard (bit 23), round (bit 22), sticky (bits 21 down to 0)
            guard_bit_s3 <= norm_product_s3[23];
            round_bit_s3 <= norm_product_s3[22];
            sticky_bit_s3 <= |norm_product_s3[21:0];

            // Round to nearest even logic: increment if guard bit is set and at least one of round, sticky, or mantissa LSB is set
            round_increment_s3 <= guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]);

            mant_rounded_s3 <= {1'b0, mantissa_s3} + round_increment_s3;

            // Handle mantissa overflow due to rounding increment
            if (mant_rounded_s3[24]) begin
                mant_rounded_final_s3 <= mant_rounded_s3[24:1];  // Shift right 1 to maintain 24 bits
                exp_rounded_s3 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s3 <= mant_rounded_s3[23:0];
                exp_rounded_s3 <= norm_exp_s3;
            end

            sign_s3 <= sign_s2;

            // -------- Output generation --------
            // Priority of special cases and overflow/underflow handling
            if (special_nan_s2) begin
                // Quiet NaN canonical: sign=0, exponent=255, mantissa MSB=1, rest 0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s2) begin
                // NaN output for Inf*Zero special case
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s2) begin
                // Infinity output with computed sign
                z <= {sign_s2, 8'hFF, 23'd0};
            end else if (special_zero_s2) begin
                // Zero output with computed sign
                z <= {sign_s2, 31'd0};
            end else if (exp_rounded_s3 >= 10'd255) begin
                // Overflow: output infinity with sign
                z <= {sign_s3, 8'hFF, 23'd0};
            end else if (exp_rounded_s3 <= 10'd0) begin
                // Underflow (including subnormal handling omitted): output zero with sign
                z <= {sign_s3, 31'd0};
            end else begin
                // Normal case: sign, exponent (8 bits), mantissa (23 bits)
                z <= {sign_s3, exp_rounded_s3[7:0], mant_rounded_final_s3[22:0]};
            end
        end
    end

endmodule