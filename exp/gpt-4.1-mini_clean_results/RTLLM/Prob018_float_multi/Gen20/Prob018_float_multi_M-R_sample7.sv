module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;
    localparam [1:0]
        SC_NONE = 2'b00,
        SC_NAN  = 2'b01,
        SC_INF  = 2'b10,
        SC_INF_ZERO_NAN = 2'b11;

    // -------- Stage 0: Input Capture --------
    reg          a_sign_s0, b_sign_s0;
    reg  [7:0]   a_exp_s0, b_exp_s0;
    reg  [22:0]  a_frac_s0, b_frac_s0;
    reg  [23:0]  a_mant_s0, b_mant_s0;
    reg          a_is_zero_s0, b_is_zero_s0;
    reg          a_is_inf_s0, b_is_inf_s0;
    reg          a_is_nan_s0, b_is_nan_s0;

    // Precompute special cases combinationally from inputs (no registers)
    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
    wire a_is_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    wire [23:0] a_mantissa_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // -------- Stage 1: Multiply and Exponent add --------
    reg          sign_s1;
    reg  [8:0]   exp_sum_s1;    // 9 bits for exponent sum with overflow bit
    reg  [47:0]  product_s1;
    reg  [1:0]   special_case_s1;

    // -------- Stage 2: Normalize, round, adjust --------
    reg          sign_s2;
    reg  [8:0]   exp_norm_s2;
    reg  [23:0]  mantissa_norm_s2;
    reg  [1:0]   special_case_s2;

    // -------- Combinational special case detection for stage 1 --------
    // Encoded special cases for stage 1:
    // 00: none, 01: NaN, 10: Inf, 11: inf*zero NaN output
    wire special_nan = a_is_nan || b_is_nan;
    wire special_inf_zero_nan = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire special_inf = (a_is_inf || b_is_inf) && !special_inf_zero_nan && !special_nan;
    wire special_zero = (a_is_zero || b_is_zero) && !special_inf_zero_nan && !special_inf && !special_nan;

    wire [1:0] special_case_s1_w =
        special_nan ? SC_NAN :
        special_inf_zero_nan ? SC_INF_ZERO_NAN :
        special_inf ? SC_INF :
        special_zero ? SC_INF_ZERO_NAN : // treat zeros like special inf_zero_nan for output NaN
        SC_NONE;

    // -------- Stage 1 combinational signals --------
    wire [47:0] product_w = a_mant_s0 * b_mant_s0;

    wire [9:0] exp_sum_10b = {1'b0, a_exp_s0} + {1'b0, b_exp_s0} - EXP_BIAS;
    wire [8:0] exp_sum_w = exp_sum_10b[8:0];

    wire sign_w = a_sign_s0 ^ b_sign_s0;

    // -------- Stage 2 normalization and rounding --------
    wire norm_shift = product_s1[47];
    wire [8:0] exp_norm_pre = exp_sum_s1 + (norm_shift ? 9'd1 : 9'd0);
    wire [47:0] product_norm = norm_shift ? (product_s1 >> 1) : product_s1;

    wire [23:0] mantissa_raw = product_norm[46:23];
    wire guard_bit = product_norm[22];
    wire round_bit = product_norm[21];
    wire sticky_bit = |product_norm[20:0];

    wire round_incr = guard_bit && (round_bit || sticky_bit || mantissa_raw[0]);

    wire [24:0] mantissa_rounded = {1'b0, mantissa_raw} + round_incr;

    wire mantissa_overflow = mantissa_rounded[24];

    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [8:0]  exp_final = mantissa_overflow ? exp_norm_pre + 9'd1 : exp_norm_pre;

    wire overflow = (exp_final[8]) || (exp_final[7:0] >= 8'hFF);
    wire underflow = (!exp_final[8]) && (exp_final[7:0] == 8'd0);

    // -------- Output values --------
    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf_result = {sign_s2, 8'hFF, 23'd0};
    wire [31:0] zero_result = {sign_s2, 31'd0};
    wire [31:0] normal_result = {sign_s2, exp_final[7:0], mantissa_final[22:0]};

    // -------- Pipeline registers --------
    // Stage 0 register block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 1'b0;
            b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0;
            b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0;
            b_frac_s0 <= 23'd0;
            a_mant_s0 <= 24'd0;
            b_mant_s0 <= 24'd0;
            a_is_zero_s0 <= 1'b0;
            b_is_zero_s0 <= 1'b0;
            a_is_inf_s0 <= 1'b0;
            b_is_inf_s0 <= 1'b0;
            a_is_nan_s0 <= 1'b0;
            b_is_nan_s0 <= 1'b0;
        end else begin
            a_sign_s0 <= a_sign;
            b_sign_s0 <= b_sign;
            a_exp_s0 <= a_exp;
            b_exp_s0 <= b_exp;
            a_frac_s0 <= a_frac;
            b_frac_s0 <= b_frac;
            a_mant_s0 <= a_mantissa_w;
            b_mant_s0 <= b_mantissa_w;
            a_is_zero_s0 <= a_is_zero;
            b_is_zero_s0 <= b_is_zero;
            a_is_inf_s0 <= a_is_inf;
            b_is_inf_s0 <= b_is_inf;
            a_is_nan_s0 <= a_is_nan;
            b_is_nan_s0 <= b_is_nan;
        end
    end

    // Stage 1 register block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_s1 <= 1'b0;
            exp_sum_s1 <= 9'd0;
            product_s1 <= 48'd0;
            special_case_s1 <= SC_NONE;
        end else begin
            sign_s1 <= sign_w;
            exp_sum_s1 <= exp_sum_w;
            product_s1 <= product_w;
            special_case_s1 <= special_case_s1_w;
        end
    end

    // Stage 2 register block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_s2 <= 1'b0;
            exp_norm_s2 <= 9'd0;
            mantissa_norm_s2 <= 24'd0;
            special_case_s2 <= SC_NONE;
            z <= 32'd0;
        end else begin
            sign_s2 <= sign_s1;
            exp_norm_s2 <= exp_final;
            mantissa_norm_s2 <= mantissa_final;
            special_case_s2 <= special_case_s1;

            // Output mux based on special cases and overflow/underflow
            case (special_case_s1)
                SC_NAN:        z <= nan_result;
                SC_INF_ZERO_NAN: z <= nan_result;
                SC_INF:        z <= inf_result;
                default: begin
                    if (overflow)
                        z <= inf_result;
                    else if (underflow)
                        z <= zero_result;
                    else
                        z <= normal_result;
                end
            endcase
        end
    end

endmodule