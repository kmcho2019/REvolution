module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Pipeline stage counter (3 bits for 5 stages: 0-4)
    reg [2:0] stage;

    // -------- Stage 0: Input capture & special case detection --------
    reg          a_sign_s0, b_sign_s0;
    reg  [7:0]   a_exp_s0, b_exp_s0;
    reg  [22:0]  a_frac_s0, b_frac_s0;
    reg          a_zero_s0, b_zero_s0;
    reg          a_inf_s0,  b_inf_s0;
    reg          a_nan_s0,  b_nan_s0;
    reg  [23:0]  a_mant_s0, b_mant_s0;

    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
    wire a_is_nan  = (a[30:23] == 8'hFF) && (|a[22:0]);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (|b[22:0]);

    wire [23:0] a_mantissa_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // -------- Stage 1: Operand register and operand gating --------
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1, b_exp_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;

    // Multiplier enable: active only if no special case and operands not zero (to save power)
    wire mul_enable = !(a_zero_s1 || b_zero_s1 || a_inf_s1 || b_inf_s1 || a_nan_s1 || b_nan_s1);

    // -------- Stage 2: Multiplication and exponent/sign calculation --------
    reg          sign_s2;
    reg  [9:0]   exp_sum_s2;    // extended 10-bit exponent sum: a_exp + b_exp - bias
    reg  [47:0]  product_s2;

    reg          zero_s2, inf_s2, nan_s2;

    // Multiply operands (mantissa) gated by mul_enable to reduce switching
    wire [47:0] product_w = mul_enable ? (a_mant_s1 * b_mant_s1) : 48'd0;

    // Exponent sum: (unsigned addition + subtraction bias)
    wire [9:0] exp_sum_w = a_exp_s1 + b_exp_s1 - EXP_BIAS;

    // Sign calculation
    wire sign_w = a_sign_s1 ^ b_sign_s1;

    // -------- Stage 3: Normalization --------
    reg          sign_s3;
    reg  [9:0]   exp_norm_s3;
    reg  [47:0]  product_s3;

    reg          zero_s3, inf_s3, nan_s3;

    // -------- Stage 4: Rounding and final output generation --------
    reg          sign_s4;
    reg  [9:0]   exp_final_s4;
    reg  [47:0]  product_s4;

    reg          zero_s4, inf_s4, nan_s4;

    // -------- Normalization signals (for Stage 4 inputs) --------
    wire norm_shift = product_s3[47];
    wire [9:0] exp_norm_pre = exp_norm_s3 + (norm_shift ? 10'd1 : 10'd0);
    wire [47:0] product_norm = norm_shift ? (product_s3 >> 1) : product_s3;

    // -------- Rounding signals (Stage 4) --------
    wire [23:0] mantissa_raw = product_norm[46:23];

    wire guard_bit = product_norm[22];
    wire round_bit = product_norm[21];
    wire sticky_bit = |product_norm[20:0];

    // Round to nearest even
    wire round_incr = guard_bit && (round_bit || sticky_bit || mantissa_raw[0]);

    wire [24:0] mantissa_rounded = {1'b0, mantissa_raw} + round_incr;
    wire mantissa_overflow = mantissa_rounded[24];

    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [9:0] exp_post_round = mantissa_overflow ? exp_norm_pre + 10'd1 : exp_norm_pre;

    // Overflow and underflow detection
    wire overflow = (exp_post_round[9]) || (exp_post_round[7:0] >= 8'hFF);
    wire underflow = (!exp_post_round[9]) && (exp_post_round[7:0] == 8'd0);

    // Special cases for output (Stage 4)
    wire nan_special_s4 = nan_s4 || (inf_s4 && zero_s4);
    wire inf_special_s4 = inf_s4 && !nan_special_s4;
    wire zero_special_s4 = zero_s4 && !inf_special_s4 && !nan_special_s4;

    wire [31:0] nan_result  = {1'b0, 8'hFF, 1'b1, 22'd0};         // Quiet NaN
    wire [31:0] inf_result  = {sign_s4, 8'hFF, 23'd0};            // Infinity
    wire [31:0] zero_result = {sign_s4, 31'd0};                   // Zero
    wire [31:0] normal_result = {sign_s4, exp_post_round[7:0], mantissa_final[22:0]};

    // -------- Pipeline registers update --------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 3'd0;

            // Stage 0 registers
            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0; b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;
            a_zero_s0 <= 1'b0; b_zero_s0 <= 1'b0;
            a_inf_s0 <= 1'b0; b_inf_s0 <= 1'b0;
            a_nan_s0 <= 1'b0; b_nan_s0 <= 1'b0;
            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;

            // Stage 1 registers
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            // Stage 2 registers
            sign_s2 <= 1'b0;
            exp_sum_s2 <= 10'd0;
            product_s2 <= 48'd0;
            zero_s2 <= 1'b0;
            inf_s2 <= 1'b0;
            nan_s2 <= 1'b0;

            // Stage 3 registers
            sign_s3 <= 1'b0;
            exp_norm_s3 <= 10'd0;
            product_s3 <= 48'd0;
            zero_s3 <= 1'b0;
            inf_s3 <= 1'b0;
            nan_s3 <= 1'b0;

            // Stage 4 registers
            sign_s4 <= 1'b0;
            exp_final_s4 <= 10'd0;
            product_s4 <= 48'd0;
            zero_s4 <= 1'b0;
            inf_s4 <= 1'b0;
            nan_s4 <= 1'b0;

            // Output
            z <= 32'd0;
        end else begin
            stage <= (stage == 3'd4) ? 3'd0 : stage + 3'd1;

            case(stage)
                3'd0: begin
                    // Capture inputs and special cases
                    a_sign_s0 <= a[31];
                    b_sign_s0 <= b[31];
                    a_exp_s0 <= a[30:23];
                    b_exp_s0 <= b[30:23];
                    a_frac_s0 <= a[22:0];
                    b_frac_s0 <= b[22:0];
                    a_zero_s0 <= a_is_zero;
                    b_zero_s0 <= b_is_zero;
                    a_inf_s0 <= a_is_inf;
                    b_inf_s0 <= b_is_inf;
                    a_nan_s0 <= a_is_nan;
                    b_nan_s0 <= b_is_nan;
                    a_mant_s0 <= a_mantissa_w;
                    b_mant_s0 <= b_mantissa_w;
                end
                3'd1: begin
                    // Register operands & special flags for multiplier gating
                    a_sign_s1 <= a_sign_s0;
                    b_sign_s1 <= b_sign_s0;
                    a_exp_s1 <= a_exp_s0;
                    b_exp_s1 <= b_exp_s0;
                    a_zero_s1 <= a_zero_s0;
                    b_zero_s1 <= b_zero_s0;
                    a_inf_s1 <= a_inf_s0;
                    b_inf_s1 <= b_inf_s0;
                    a_nan_s1 <= a_nan_s0;
                    b_nan_s1 <= b_nan_s0;
                    a_mant_s1 <= a_mant_s0;
                    b_mant_s1 <= b_mant_s0;
                end
                3'd2: begin
                    // Multiply mantissas and add exponents/sign
                    product_s2 <= product_w;
                    exp_sum_s2 <= exp_sum_w;
                    sign_s2 <= sign_w;
                    zero_s2 <= a_zero_s1 || b_zero_s1;
                    inf_s2 <= a_inf_s1 || b_inf_s1;
                    nan_s2 <= a_nan_s1 || b_nan_s1;
                end
                3'd3: begin
                    // Normalization stage
                    product_s3 <= product_s2;
                    exp_norm_s3 <= exp_sum_s2;
                    sign_s3 <= sign_s2;
                    zero_s3 <= zero_s2;
                    inf_s3 <= inf_s2;
                    nan_s3 <= nan_s2;
                end
                3'd4: begin
                    // Rounding & output stage
                    product_s4 <= product_s3;
                    exp_final_s4 <= exp_norm_pre;  // Adjusted exponent with normalization shift
                    sign_s4 <= sign_s3;
                    zero_s4 <= zero_s3;
                    inf_s4 <= inf_s3;
                    nan_s4 <= nan_s3;

                    // Final output decision
                    if (nan_special_s4) begin
                        z <= nan_result;
                    end else if (inf_special_s4) begin
                        z <= inf_result;
                    end else if (zero_special_s4) begin
                        z <= zero_result;
                    end else begin
                        if (overflow) begin
                            z <= inf_result;
                        end else if (underflow) begin
                            z <= zero_result;
                        end else begin
                            z <= normal_result;
                        end
                    end
                end
            endcase
        end
    end
endmodule