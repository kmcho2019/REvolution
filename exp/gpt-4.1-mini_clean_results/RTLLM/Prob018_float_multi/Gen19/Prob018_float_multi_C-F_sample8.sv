module float_multi (
    input              clk,
    input              rst,         // synchronous active high reset
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);

    // IEEE 754 single precision parameters
    localparam EXP_BIAS   = 127;
    localparam EXP_INF_NAN = 8'hFF;
    localparam EXP_ZERO   = 8'd0;

    // Pipeline stage counter: cycles 0->1->2->0...
    reg [1:0] counter;

    // --- Stage 0: Input Capture and Special Case Detection ---

    reg         a_sign_s0, b_sign_s0;
    reg  [7:0]  a_exp_s0,  b_exp_s0;
    reg  [22:0] a_frac_s0, b_frac_s0;

    reg         a_zero_s0, b_zero_s0;
    reg         a_inf_s0,  b_inf_s0;
    reg         a_nan_s0,  b_nan_s0;

    reg  [23:0] a_mant_s0, b_mant_s0; // mantissa with implicit 1 for normal, 0 for denorm/zero

    // --- Stage 1: Mantissa Multiply, Exponent Add, Sign XOR, Special Flags ---

    reg         sign_s1;
    reg  [9:0]  exp_sum_s1;      // 10 bits to hold exponent sum - bias + possible carry
    reg  [47:0] product_s1;      // mantissa multiplication product

    reg         a_zero_s1, b_zero_s1;
    reg         a_inf_s1,  b_inf_s1;
    reg         a_nan_s1,  b_nan_s1;

    reg         special_infzero_nan_s1; // Inf*Zero => NaN flag

    // --- Stage 2: Normalization, Rounding, Exponent Adjust, Final Output Assemble ---

    reg         sign_s2;
    reg  [9:0]  exp_sum_s2;
    reg  [47:0] product_s2;

    reg         a_zero_s2, b_zero_s2;
    reg         a_inf_s2,  b_inf_s2;
    reg         a_nan_s2,  b_nan_s2;
    reg         special_infzero_nan_s2;

    reg  [31:0] result_stage2;

    // ------------------- Stage 0 Combinational Signals -------------------

    wire a_is_zero = (a[30:23] == EXP_ZERO) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == EXP_ZERO) && (b[22:0] == 23'd0);

    wire a_is_inf  = (a[30:23] == EXP_INF_NAN) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == EXP_INF_NAN) && (b[22:0] == 23'd0);

    wire a_is_nan  = (a[30:23] == EXP_INF_NAN) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b[30:23] == EXP_INF_NAN) && (b[22:0] != 23'd0);

    // Mantissas with implicit bit: 1 for normal, 0 for denormals and zero
    wire [23:0] a_mantissa_w = (a[30:23] == EXP_ZERO) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == EXP_ZERO) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Extend exponents to 10 bits for intermediate calculations:
    // Denormals treated as exponent 1 to avoid negative exponent during addition (corrected after)
    wire [9:0] a_exp_10b = (a[30:23] == EXP_ZERO) ? 10'd1 : {2'b00, a[30:23]};
    wire [9:0] b_exp_10b = (b[30:23] == EXP_ZERO) ? 10'd1 : {2'b00, b[30:23]};
    wire [9:0] exp_sum_w = a_exp_10b + b_exp_10b - EXP_BIAS;

    // Mantissa product (24x24 = 48 bits)
    wire [47:0] product_w = a_mantissa_w * b_mantissa_w;

    // Sign XOR
    wire sign_w = a[31] ^ b[31];

    // Special Inf*Zero case produces NaN
    wire special_infzero_nan_w = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // ------------------- Stage 2 Combinational Logic -------------------

    // Normalize: if MSB=1 (bit 47), shift right 1 and increment exponent
    wire product_msb = product_s2[47];
    wire [47:0] normalized_product = product_msb ? (product_s2 >> 1) : product_s2;
    wire [9:0] normalized_exp = product_msb ? (exp_sum_s2 + 10'd1) : exp_sum_s2;

    // Mantissa: bits [46:23] (24 bits)
    wire [23:0] mantissa_24 = normalized_product[46:23];

    // Rounding bits (guard, round, sticky)
    wire guard_bit = normalized_product[22];
    wire round_bit = normalized_product[21];
    wire sticky_bit = |normalized_product[20:0]; // OR reduction for sticky

    // Round increment decision: round to nearest even
    wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_24[0]);

    // Apply rounding increment (25 bits for carry)
    wire [24:0] mantissa_rounded = {1'b0, mantissa_24} + (round_increment ? 25'd1 : 25'd0);

    // Check if rounding overflow happened (carry out)
    wire mantissa_carry = mantissa_rounded[24];

    // Adjust mantissa and exponent if carry out from rounding
    wire [23:0] mantissa_final = mantissa_carry ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [9:0] exponent_final = mantissa_carry ? (normalized_exp + 10'd1) : normalized_exp;

    // Exponent overflow/underflow detection
    wire exponent_overflow = (exponent_final >= 10'd255);
    wire exponent_underflow = (exponent_final <= 10'd0);

    // Final exponent output
    wire [7:0] exponent_out = exponent_overflow ? 8'hFF :
                             exponent_underflow ? 8'd0 :
                             exponent_final[7:0];

    // Canonical quiet NaN: sign=0, exponent=255, mantissa MSB=1, rest 0
    wire [31:0] nan_qnan = {1'b0, 8'hFF, 1'b1, 22'd0};

    // Infinity with sign
    wire [31:0] inf_value = {sign_s2, 8'hFF, 23'd0};

    // Zero with sign
    wire [31:0] zero_value = {sign_s2, 31'd0};

    // Normal result
    wire [31:0] normal_value = {sign_s2, exponent_out, mantissa_final[22:0]};

    // Final output mux with priority:
    // 1) NaN inputs propagate
    // 2) Inf*Zero => NaN
    // 3) Inf * non-zero => Inf
    // 4) Zero * non-inf => Zero
    // 5) Exponent overflow => Inf
    // 6) Exponent underflow => Zero
    // 7) Normal number
    always @(*) begin
        if (a_nan_s2 || b_nan_s2) begin
            result_stage2 = nan_qnan;
        end else if (special_infzero_nan_s2) begin
            result_stage2 = nan_qnan;
        end else if (a_inf_s2 || b_inf_s2) begin
            result_stage2 = inf_value;
        end else if (a_zero_s2 || b_zero_s2) begin
            result_stage2 = zero_value;
        end else begin
            if (exponent_overflow) begin
                result_stage2 = inf_value;
            end else if (exponent_underflow) begin
                result_stage2 = zero_value;
            end else begin
                result_stage2 = normal_value;
            end
        end
    end

    // ------------------- Pipeline Registers and Control -------------------
    always @(posedge clk) begin
        if (rst) begin
            counter <= 2'd0;

            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0;  b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;
            a_zero_s0 <= 1'b0; b_zero_s0 <= 1'b0;
            a_inf_s0 <= 1'b0;  b_inf_s0 <= 1'b0;
            a_nan_s0 <= 1'b0;  b_nan_s0 <= 1'b0;
            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;

            sign_s1 <= 1'b0;
            exp_sum_s1 <= 10'd0;
            product_s1 <= 48'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0;  b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0;  b_nan_s1 <= 1'b0;
            special_infzero_nan_s1 <= 1'b0;

            sign_s2 <= 1'b0;
            exp_sum_s2 <= 10'd0;
            product_s2 <= 48'd0;
            a_zero_s2 <= 1'b0; b_zero_s2 <= 1'b0;
            a_inf_s2 <= 1'b0;  b_inf_s2 <= 1'b0;
            a_nan_s2 <= 1'b0;  b_nan_s2 <= 1'b0;
            special_infzero_nan_s2 <= 1'b0;

            z <= 32'd0;
        end else begin
            counter <= counter + 2'd1;

            case (counter)
                2'd0: begin
                    // Stage 0: Input capture and special cases
                    a_sign_s0 <= a[31];
                    b_sign_s0 <= b[31];
                    a_exp_s0 <= a[30:23];
                    b_exp_s0 <= b[30:23];
                    a_frac_s0 <= a[22:0];
                    b_frac_s0 <= b[22:0];

                    a_zero_s0 <= a_is_zero;
                    b_zero_s0 <= b_is_zero;
                    a_inf_s0  <= a_is_inf;
                    b_inf_s0  <= b_is_inf;
                    a_nan_s0  <= a_is_nan;
                    b_nan_s0  <= b_is_nan;

                    a_mant_s0 <= a_mantissa_w;
                    b_mant_s0 <= b_mantissa_w;
                end

                2'd1: begin
                    // Stage 1: Multiply mantissas, exponent add, sign XOR, propagate flags
                    sign_s1 <= sign_w;
                    exp_sum_s1 <= exp_sum_w;
                    product_s1 <= product_w;

                    a_zero_s1 <= a_zero_s0;
                    b_zero_s1 <= b_zero_s0;
                    a_inf_s1  <= a_inf_s0;
                    b_inf_s1  <= b_inf_s0;
                    a_nan_s1  <= a_nan_s0;
                    b_nan_s1  <= b_nan_s0;

                    special_infzero_nan_s1 <= special_infzero_nan_w;
                end

                2'd2: begin
                    // Stage 2: Normalize, round, exponent adjust, final output assemble
                    sign_s2 <= sign_s1;
                    exp_sum_s2 <= exp_sum_s1;
                    product_s2 <= product_s1;

                    a_zero_s2 <= a_zero_s1;
                    b_zero_s2 <= b_zero_s1;
                    a_inf_s2  <= a_inf_s1;
                    b_inf_s2  <= b_inf_s1;
                    a_nan_s2  <= a_nan_s1;
                    b_nan_s2  <= b_nan_s1;

                    special_infzero_nan_s2 <= special_infzero_nan_s1;

                    // Output stage: register the final result computed combinationally
                    z <= result_stage2;
                end
            endcase
        end
    end
endmodule