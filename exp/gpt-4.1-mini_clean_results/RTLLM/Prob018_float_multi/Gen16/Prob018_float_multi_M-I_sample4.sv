module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Pipeline counter for state tracking (not strictly needed but kept for clarity)
    reg [1:0] stage;

    // Stage 0: Input capture and special case detection registers
    reg          a_sign_s0, b_sign_s0;
    reg  [7:0]   a_exp_s0, b_exp_s0;
    reg  [22:0]  a_frac_s0, b_frac_s0;

    // Special cases flags at stage 0
    reg          a_zero_s0, b_zero_s0;
    reg          a_inf_s0,  b_inf_s0;
    reg          a_nan_s0,  b_nan_s0;

    // Mantissas stage 0
    reg  [23:0]  a_mant_s0, b_mant_s0;

    // Stage 1: Registered mantissa inputs for multiplication
    reg          a_sign_s1, b_sign_s1;
    reg  [7:0]   a_exp_s1, b_exp_s1;
    reg          a_zero_s1, b_zero_s1;
    reg          a_inf_s1,  b_inf_s1;
    reg          a_nan_s1,  b_nan_s1;
    reg  [23:0]  a_mant_s1, b_mant_s1;

    // Stage 2: Multiplication product and exponent/sign calculation registers
    reg          sign_s2;
    reg  [9:0]   exp_sum_s2;    // 10 bits to hold sum + intermediate carries
    reg  [47:0]  product_s2;

    reg          zero_s2, inf_s2, nan_s2;

    // Stage 3: Normalization, rounding, and output generation registers
    reg          sign_s3;
    reg  [9:0]   exp_norm_s3;
    reg  [47:0]  product_s3;

    reg          zero_s3, inf_s3, nan_s3;

    // ----- Stage 0 special case detection and mantissa extraction -----
    wire a_is_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
    wire a_is_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
    wire a_is_nan  = (a[30:23] == 8'hFF) && (|a[22:0]);
    wire b_is_nan  = (b[30:23] == 8'hFF) && (|b[22:0]);

    wire [23:0] a_mantissa_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mantissa_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // 24x24 bit product wire
    wire [47:0] product_w = a_mant_s1 * b_mant_s1;

    // Exponent sum (10 bits: to hold potential overflow)
    wire [9:0] exp_sum_w = a_exp_s1 + b_exp_s1 - EXP_BIAS;

    // Sign calculation
    wire sign_w = a_sign_s1 ^ b_sign_s1;

    // Special cases for stage 3 output:
    // NaN if any input is NaN OR inf*0 or 0*inf
    wire nan_special_s3 = nan_s3 || (inf_s3 && zero_s3);
    wire inf_special_s3 = inf_s3 && !nan_special_s3;
    wire zero_special_s3 = zero_s3 && !inf_special_s3 && !nan_special_s3;

    // Stage 3 normalization and rounding computations

    // Normalization shift needed if product[47] == 1
    wire norm_shift = product_s3[47];

    // Adjusted exponent after normalization shift
    wire [9:0] exp_norm_pre = exp_norm_s3 + (norm_shift ? 10'd1 : 10'd0);

    // Normalized product (shift right if normalized)
    wire [47:0] product_norm = norm_shift ? (product_s3 >> 1) : product_s3;

    // Extract mantissa bits [46:23] (24 bits)
    wire [23:0] mantissa_raw = product_norm[46:23];

    // Rounding bits
    wire guard_bit = product_norm[22];
    wire round_bit = product_norm[21];
    wire sticky_bit = |product_norm[20:0];

    // Round increment condition (round to nearest, ties to even)
    wire round_incr = guard_bit && (round_bit || sticky_bit || mantissa_raw[0]);

    // Mantissa with rounding increment (25 bits to catch carry)
    wire [24:0] mantissa_rounded = {1'b0, mantissa_raw} + round_incr;

    // Check mantissa overflow after rounding
    wire mantissa_overflow = mantissa_rounded[24];

    // Adjust mantissa and exponent after rounding overflow
    wire [23:0] mantissa_final = mantissa_overflow ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [9:0]  exp_final = mantissa_overflow ? exp_norm_pre + 10'd1 : exp_norm_pre;

    // Overflow and underflow detection
    wire overflow = (exp_final[9]) || (exp_final[7:0] >= 8'hFF);
    wire underflow = (!exp_final[9]) && (exp_final[7:0] == 8'd0);

    // IEEE 754 outputs for special cases
    wire [31:0] nan_result = {1'b0, 8'hFF, 1'b1, 22'd0};         // Quiet NaN with leading 1 in fraction
    wire [31:0] inf_result = {sign_s3, 8'hFF, 23'd0};             // Infinity
    wire [31:0] zero_result = {sign_s3, 31'd0};                   // Zero
    wire [31:0] normal_result = {sign_s3, exp_final[7:0], mantissa_final[22:0]};

    // Pipeline registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 2'd0;
            // Reset all pipeline registers
            a_sign_s0 <= 1'b0; b_sign_s0 <= 1'b0;
            a_exp_s0 <= 8'd0; b_exp_s0 <= 8'd0;
            a_frac_s0 <= 23'd0; b_frac_s0 <= 23'd0;
            a_zero_s0 <= 1'b0; b_zero_s0 <= 1'b0;
            a_inf_s0 <= 1'b0; b_inf_s0 <= 1'b0;
            a_nan_s0 <= 1'b0; b_nan_s0 <= 1'b0;
            a_mant_s0 <= 24'd0; b_mant_s0 <= 24'd0;

            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            product_s2 <= 48'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            zero_s2 <= 1'b0; inf_s2 <= 1'b0; nan_s2 <= 1'b0;

            product_s3 <= 48'd0;
            exp_norm_s3 <= 10'd0;
            sign_s3 <= 1'b0;
            zero_s3 <= 1'b0; inf_s3 <= 1'b0; nan_s3 <= 1'b0;

            z <= 32'd0;
        end else begin
            stage <= stage + 2'd1;

            case (stage)
                2'd0: begin
                    // Capture inputs and detect special cases
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
                2'd1: begin
                    // Register mantissas and control signals for multiplication stage
                    a_sign_s1 <= a_sign_s0;
                    b_sign_s1 <= b_sign_s0;
                    a_exp_s1 <= a_exp_s0;
                    b_exp_s1 <= b_exp_s0;
                    a_zero_s1 <= a_zero_s0;
                    b_zero_s1 <= b_zero_s0;
                    a_inf_s1  <= a_inf_s0;
                    b_inf_s1  <= b_inf_s0;
                    a_nan_s1  <= a_nan_s0;
                    b_nan_s1  <= b_nan_s0;
                    a_mant_s1 <= a_mant_s0;
                    b_mant_s1 <= b_mant_s0;
                end
                2'd2: begin
                    // Perform mantissa multiplication and exponent addition
                    product_s2 <= product_w;
                    exp_sum_s2 <= exp_sum_w;
                    sign_s2 <= sign_w;

                    // Special cases propagate and combine
                    zero_s2 <= a_zero_s1 || b_zero_s1;
                    inf_s2  <= a_inf_s1 || b_inf_s1;
                    nan_s2  <= a_nan_s1 || b_nan_s1;
                end
                2'd3: begin
                    // Normalization, rounding, final exponent calculation
                    product_s3 <= product_s2;
                    exp_norm_s3 <= exp_sum_s2;
                    sign_s3 <= sign_s2;

                    zero_s3 <= zero_s2;
                    inf_s3 <= inf_s2;
                    nan_s3 <= nan_s2;

                    // Output final result
                    if (nan_special_s3) begin
                        z <= nan_result;
                    end else if (inf_special_s3) begin
                        z <= inf_result;
                    end else if (zero_special_s3) begin
                        z <= zero_result;
                    end else begin
                        // Normal result handling with overflow/underflow
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