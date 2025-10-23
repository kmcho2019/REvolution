module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Pipeline registers stage 0
    reg a_sign_s0, b_sign_s0;
    reg [7:0] a_exp_s0, b_exp_s0;
    reg [22:0] a_frac_s0, b_frac_s0;
    reg a_zero_s0, b_zero_s0;
    reg a_inf_s0, b_inf_s0;
    reg a_nan_s0, b_nan_s0;

    // Mantissas with explicit leading 1 (or 0 if denormal)
    reg [24:0] a_mant_s0, b_mant_s0; // 1 bit leading + 23 frac + 1 zero padding

    // Pipeline registers stage 1 (start multiply)
    reg a_sign_s1, b_sign_s1;
    reg [7:0] a_exp_s1, b_exp_s1;
    reg a_zero_s1, b_zero_s1;
    reg a_inf_s1, b_inf_s1;
    reg a_nan_s1, b_nan_s1;
    reg [24:0] a_mant_s1, b_mant_s1;

    // Partial product signals
    reg [49:0] product_s1; // 25x25=50 bits

    // Pipeline registers stage 2 (finish multiply + normalization prep)
    reg sign_res_s2;
    reg [9:0] exp_sum_s2;
    reg [49:0] product_s2;
    reg a_zero_s2, b_zero_s2;
    reg a_inf_s2, b_inf_s2;
    reg a_nan_s2, b_nan_s2;

    // Normalized mantissa & exponent before rounding
    reg [24:0] norm_mant_s2;
    reg [9:0] norm_exp_s2;

    // Rounding bits stored for stage 3
    reg guard_bit_s2, round_bit_s2, sticky_bit_s2;

    // Pipeline stage 3 registers (rounding, special cases, output)
    reg sign_res_s3;
    reg [9:0] norm_exp_s3;
    reg [24:0] norm_mant_s3;
    reg guard_bit_s3, round_bit_s3, sticky_bit_s3;
    reg a_zero_s3, b_zero_s3;
    reg a_inf_s3, b_inf_s3;
    reg a_nan_s3, b_nan_s3;

    // Final rounding results
    reg [24:0] mantissa_rounded_s3;
    reg [9:0] exponent_rounded_s3;

    // Cycle 0: Extract fields, special cases, mantissas
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0; b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;
            a_zero_s0 <= 0; b_zero_s0 <= 0;
            a_inf_s0 <= 0; b_inf_s0 <= 0;
            a_nan_s0 <= 0; b_nan_s0 <= 0;
            a_mant_s0 <= 0; b_mant_s0 <= 0;
        end else begin
            // Extract sign, exponent, fraction
            a_sign_s0 <= a[31];
            b_sign_s0 <= b[31];
            a_exp_s0 <= a[30:23];
            b_exp_s0 <= b[30:23];
            a_frac_s0 <= a[22:0];
            b_frac_s0 <= b[22:0];

            // Detect zeros (exponent=0, frac=0)
            a_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            // Detect infinity (exp=255 frac=0)
            a_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            // Detect NaN (exp=255 frac!=0)
            a_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Form mantissa with explicit leading 1 for normal, 0 for denormal
            // Add an extra zero LSB bit for rounding alignment later
            a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0], 1'b0} : {1'b1, a[22:0], 1'b0};
            b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0], 1'b0} : {1'b1, b[22:0], 1'b0};
        end
    end

    // Pipeline stage 1: Start multiply mantissas, propagate fields
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign_s1 <= 0; b_sign_s1 <= 0;
            a_exp_s1 <= 0; b_exp_s1 <= 0;
            a_zero_s1 <= 0; b_zero_s1 <= 0;
            a_inf_s1 <= 0; b_inf_s1 <= 0;
            a_nan_s1 <= 0; b_nan_s1 <= 0;
            a_mant_s1 <= 0; b_mant_s1 <= 0;
            product_s1 <= 0;
        end else begin
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

            // Multiply mantissas: 25 x 25 = 50 bits product
            product_s1 <= a_mant_s0 * b_mant_s0;
        end
    end

    // Pipeline stage 2: Normalize product, exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_res_s2 <= 0;
            exp_sum_s2 <= 0;
            product_s2 <= 0;
            a_zero_s2 <= 0;
            b_zero_s2 <= 0;
            a_inf_s2 <= 0;
            b_inf_s2 <= 0;
            a_nan_s2 <= 0;
            b_nan_s2 <= 0;

            norm_mant_s2 <= 0;
            norm_exp_s2 <= 0;
            guard_bit_s2 <= 0;
            round_bit_s2 <= 0;
            sticky_bit_s2 <= 0;
        end else begin
            a_zero_s2 <= a_zero_s1;
            b_zero_s2 <= b_zero_s1;
            a_inf_s2 <= a_inf_s1;
            b_inf_s2 <= b_inf_s1;
            a_nan_s2 <= a_nan_s1;
            b_nan_s2 <= b_nan_s1;

            sign_res_s2 <= a_sign_s1 ^ b_sign_s1;

            // Exponent sum: subtract bias 127
            exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;

            product_s2 <= product_s1;

            // Normalize product_s2:
            // If MSB (bit 49) is 1, shift right 1 and increment exponent
            if (product_s1[49]) begin
                norm_mant_s2 <= product_s1[49:25]; // top 25 bits (for rounding)
                norm_exp_s2 <= exp_sum_s2 + 10'd1;
                guard_bit_s2 <= product_s1[24];
                round_bit_s2 <= product_s1[23];
                sticky_bit_s2 <= |product_s1[22:0];
            end else begin
                norm_mant_s2 <= product_s1[48:24]; // top 25 bits shifted left by 1 (no normalization shift)
                norm_exp_s2 <= exp_sum_s2;
                guard_bit_s2 <= product_s1[23];
                round_bit_s2 <= product_s1[22];
                sticky_bit_s2 <= |product_s1[21:0];
            end
        end
    end

    // Pipeline stage 3: Rounding, special cases handling, output formation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sign_res_s3 <= 0;
            norm_exp_s3 <= 0;
            norm_mant_s3 <= 0;
            guard_bit_s3 <= 0;
            round_bit_s3 <= 0;
            sticky_bit_s3 <= 0;
            a_zero_s3 <= 0;
            b_zero_s3 <= 0;
            a_inf_s3 <= 0;
            b_inf_s3 <= 0;
            a_nan_s3 <= 0;
            b_nan_s3 <= 0;
            mantissa_rounded_s3 <= 0;
            exponent_rounded_s3 <= 0;
            z <= 32'd0;
        end else begin
            sign_res_s3 <= sign_res_s2;
            norm_exp_s3 <= norm_exp_s2;
            norm_mant_s3 <= norm_mant_s2;
            guard_bit_s3 <= guard_bit_s2;
            round_bit_s3 <= round_bit_s2;
            sticky_bit_s3 <= sticky_bit_s2;
            a_zero_s3 <= a_zero_s2;
            b_zero_s3 <= b_zero_s2;
            a_inf_s3 <= a_inf_s2;
            b_inf_s3 <= b_inf_s2;
            a_nan_s3 <= a_nan_s2;
            b_nan_s3 <= b_nan_s2;

            // Handle special cases first:
            if (a_nan_s2 || b_nan_s2) begin
                // Quiet NaN: sign=0, exp=255, MSB mantissa=1 (quiet NaN convention)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf_s2 && b_zero_s2) || (b_inf_s2 && a_zero_s2)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf_s2 || b_inf_s2) begin
                // Inf * anything else = Inf with sign
                z <= {sign_res_s2, 8'hFF, 23'd0};
            end else if (a_zero_s2 || b_zero_s2) begin
                // Zero result with sign
                z <= {sign_res_s2, 31'd0};
            end else begin
                // Normal rounding: round to nearest even

                // Round increment if guard=1 and (round or sticky or LSB=1)
                if (guard_bit_s2 && (round_bit_s2 || sticky_bit_s2 || norm_mant_s2[0]))
                    mantissa_rounded_s3 <= norm_mant_s2 + 25'd1;
                else
                    mantissa_rounded_s3 <= norm_mant_s2;

                // Check if mantissa overflows 25 bits (i.e., bit 24 set)
                if (mantissa_rounded_s3[24]) begin
                    exponent_rounded_s3 <= norm_exp_s3 + 10'd1;
                    // Shift mantissa right by 1 (drop lowest bit)
                    // Output fraction bits: bits [23:1]
                    if (exponent_rounded_s3 >= 10'd255) begin
                        // Overflow to infinity
                        z <= {sign_res_s3, 8'hFF, 23'd0};
                    end else begin
                        z <= {sign_res_s3, exponent_rounded_s3[7:0], mantissa_rounded_s3[23:1]};
                    end
                end else begin
                    exponent_rounded_s3 <= norm_exp_s3;
                    // Check exponent for overflow/underflow
                    if (exponent_rounded_s3 >= 10'd255) begin
                        // Overflow to infinity
                        z <= {sign_res_s3, 8'hFF, 23'd0};
                    end else if (exponent_rounded_s3 <= 0) begin
                        // Underflow: flush to zero (no gradual underflow for simplicity)
                        z <= {sign_res_s3, 31'd0};
                    end else begin
                        z <= {sign_res_s3, exponent_rounded_s3[7:0], mantissa_rounded_s3[22:0]};
                    end
                end
            end
        end
    end

endmodule