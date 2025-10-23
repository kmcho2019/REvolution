module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // --- Stage 1: Input extraction and special case detection ---
    reg        a_sign_s1, b_sign_s1;
    reg  [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg        a_zero_s1, b_zero_s1;
    reg        a_inf_s1,  b_inf_s1;
    reg        a_nan_s1,  b_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1; // Mantissas with hidden bit

    // --- Stage 2: Prepare multiplier inputs, exponent sum, sign, special flags ---
    reg [23:0] a_mant_s2, b_mant_s2;
    reg [9:0]  exp_sum_s2; // sum of exponents minus bias (to allow overflow detection)
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // --- Stage 3: Multiplier output and normalization ---
    reg [47:0] product_s3;
    reg [47:0] norm_product_s3;
    reg [9:0]  norm_exp_s3;
    reg        sign_s3;
    reg        special_nan_s3;
    reg        special_nan_out_s3;
    reg        special_inf_s3;
    reg        special_zero_s3;
    reg        guard_bit_s3;
    reg        round_bit_s3;
    reg        sticky_bit_s3;
    reg [23:0] mantissa_s3;

    // --- Stage 4: Rounding, special cases, final output ---
    reg        sign_s4;
    reg        special_nan_s4;
    reg        special_nan_out_s4;
    reg        special_inf_s4;
    reg        special_zero_s4;
    reg [24:0] mant_rounded_s4;
    reg [23:0] mant_rounded_final_s4;
    reg [9:0]  exp_rounded_s4;

    // Helper functions for special case checks
    function is_zero(input [7:0] e, input [22:0] f);
        begin
            is_zero = (e == 8'd0) && (f == 23'd0);
        end
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        begin
            is_inf = (e == 8'hFF) && (f == 23'd0);
        end
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        begin
            is_nan = (e == 8'hFF) && (f != 23'd0);
        end
    endfunction

    // Stage 1 combinational wires for input special cases and mantissas
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w  = is_inf(a[30:23], a[22:0]);
    wire b_inf_w  = is_inf(b[30:23], b[22:0]);
    wire a_nan_w  = is_nan(a[30:23], a[22:0]);
    wire b_nan_w  = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Sticky bit computation helper (hierarchical OR) for 22 bits
    wire sticky_or_hi_s3 = |norm_product_s3[21:6];  // upper 16 bits
    wire sticky_or_lo_s3 = |norm_product_s3[5:0];   // lower 6 bits
    wire sticky_bit_combined_s3 = sticky_or_hi_s3 | sticky_or_lo_s3;

    // Stage 1: Extract inputs and detect special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;
        end else begin
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
        end
    end

    // Stage 2: Prepare for multiplication, exponent sum, sign, special cases
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mant_s2 <= 24'd0; b_mant_s2 <= 24'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;
        end else begin
            a_mant_s2 <= a_mant_s1;
            b_mant_s2 <= b_mant_s1;
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
            sign_s2 <= a_sign_s1 ^ b_sign_s1;

            // Special cases
            special_nan_s2 <= a_nan_s1 || b_nan_s1;
            // NaN output from Inf*Zero special case
            special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
            special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
            special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;
        end
    end

    // Stage 3: Multiply mantissas and normalize product
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s3 <= 48'd0;
            norm_product_s3 <= 48'd0;
            norm_exp_s3 <= 10'd0;
            sign_s3 <= 1'b0;
            special_nan_s3 <= 1'b0;
            special_nan_out_s3 <= 1'b0;
            special_inf_s3 <= 1'b0;
            special_zero_s3 <= 1'b0;
            guard_bit_s3 <= 1'b0;
            round_bit_s3 <= 1'b0;
            sticky_bit_s3 <= 1'b0;
            mantissa_s3 <= 24'd0;
        end else begin
            // Multiply
            product_s3 <= a_mant_s2 * b_mant_s2;

            sign_s3 <= sign_s2;
            special_nan_s3 <= special_nan_s2;
            special_nan_out_s3 <= special_nan_out_s2;
            special_inf_s3 <= special_inf_s2;
            special_zero_s3 <= special_zero_s2;

            // Normalization: if MSB (bit 47) is 1, shift right by 1 and increment exponent
            if ((a_mant_s2 * b_mant_s2)[47]) begin
                norm_product_s3 <= (a_mant_s2 * b_mant_s2) >> 1;
                norm_exp_s3 <= exp_sum_s2 + 10'd1;
            end else begin
                norm_product_s3 <= (a_mant_s2 * b_mant_s2);
                norm_exp_s3 <= exp_sum_s2;
            end

            // Extract mantissa and rounding bits
            // mantissa: bits [46:23] (24 bits including implicit leading 1)
            mantissa_s3 <= norm_product_s3[46:23];
            guard_bit_s3 <= norm_product_s3[22];
            round_bit_s3 <= norm_product_s3[21];
            // Sticky bit is OR of bits [20:0], calculated hierarchically below
            sticky_bit_s3 <= sticky_bit_combined_s3;
        end
    end

    // Stage 4: Rounding, special case handling, final output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_s4 <= 1'b0;
            special_nan_s4 <= 1'b0;
            special_nan_out_s4 <= 1'b0;
            special_inf_s4 <= 1'b0;
            special_zero_s4 <= 1'b0;
            mant_rounded_s4 <= 25'd0;
            mant_rounded_final_s4 <= 24'd0;
            exp_rounded_s4 <= 10'd0;
            z <= 32'd0;
        end else begin
            sign_s4 <= sign_s3;
            special_nan_s4 <= special_nan_s3;
            special_nan_out_s4 <= special_nan_out_s3;
            special_inf_s4 <= special_inf_s3;
            special_zero_s4 <= special_zero_s3;

            // Round to nearest even
            // increment mantissa if guard bit =1 and (round bit or sticky bit or LSB of mantissa)
            if (guard_bit_s3 && (round_bit_s3 || sticky_bit_s3 || mantissa_s3[0]))
                mant_rounded_s4 <= {1'b0, mantissa_s3} + 25'd1;
            else
                mant_rounded_s4 <= {1'b0, mantissa_s3};

            // If mantissa overflows (bit 24 set after rounding), shift right and increment exponent
            if (mant_rounded_s4[24]) begin
                mant_rounded_final_s4 <= mant_rounded_s4[24:1];
                exp_rounded_s4 <= norm_exp_s3 + 10'd1;
            end else begin
                mant_rounded_final_s4 <= mant_rounded_s4[23:0];
                exp_rounded_s4 <= norm_exp_s3;
            end

            // Output logic with priority:
            // NaN (quiet), NaN from Inf*Zero, Inf, Zero, Overflow, Underflow, Normal

            if (special_nan_s4) begin
                // Quiet NaN: sign=0, exp=all ones, MSB fraction=1, rest 0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_nan_out_s4) begin
                // NaN from Inf*0
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (special_inf_s4) begin
                // Infinity with sign
                z <= {sign_s4, 8'hFF, 23'd0};
            end else if (special_zero_s4) begin
                // Zero with sign
                z <= {sign_s4, 31'd0};
            end else if (exp_rounded_s4[9:8] != 2'b00) begin
                // Exponent overflow (greater than 255) => infinity
                z <= {sign_s4, 8'hFF, 23'd0};
            end else if (exp_rounded_s4[7:0] == 8'd0) begin
                // Underflow (flush to zero, no gradual underflow handled)
                z <= {sign_s4, 31'd0};
            end else begin
                // Normal case
                z <= {sign_s4, exp_rounded_s4[7:0], mant_rounded_final_s4[22:0]};
            end
        end
    end

endmodule