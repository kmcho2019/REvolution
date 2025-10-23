module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z,
    output reg valid
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;
    localparam EXP_ZERO = 8'h00;

    // Pipeline stage registers for sign, exponent, mantissa and flags

    // Stage 0: Input extraction and special case detection
    reg a_sign_s0, b_sign_s0;
    reg [7:0] a_exp_s0, b_exp_s0;
    reg [22:0] a_frac_s0, b_frac_s0;
    reg a_is_zero_s0, b_is_zero_s0;
    reg a_is_inf_s0, b_is_inf_s0;
    reg a_is_nan_s0, b_is_nan_s0;

    // Stage 1: Multiplication and exponent addition
    reg z_sign_s1;
    reg [9:0] z_exp_s1;         // wider to hold exponent sum - bias
    reg [47:0] product_s1;      // product of mantissas (24x24=48 bits)
    reg mul_denorm_s1;          // if either input is denormal (exp=0 and frac!=0)
    reg special_case_s1;
    reg [31:0] special_result_s1;

    // Stage 2: Normalization, rounding, output generation
    reg z_sign_s2;
    reg [9:0] z_exp_s2;
    reg [23:0] mantissa_norm_s2; // normalized 24-bit mantissa (with implicit leading 1)
    reg guard_s2, round_s2, sticky_s2;
    reg special_case_s2;
    reg [31:0] special_result_s2;

    // Helper wires for extraction at stage0
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Combinational logic for stage0 input extraction and special case detection
    always @(posedge clk) begin
        if (rst) begin
            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0; b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;
            a_is_zero_s0 <= 0; b_is_zero_s0 <= 0;
            a_is_inf_s0 <= 0; b_is_inf_s0 <= 0;
            a_is_nan_s0 <= 0; b_is_nan_s0 <= 0;
            z <= 0;
            valid <= 0;
        end else begin
            a_sign_s0 <= a_s;
            b_sign_s0 <= b_s;
            a_exp_s0 <= a_exp;
            b_exp_s0 <= b_exp;
            a_frac_s0 <= a_frac;
            b_frac_s0 <= b_frac;

            // Detect zeros
            a_is_zero_s0 <= (a_exp == EXP_ZERO) && (a_frac == 0);
            b_is_zero_s0 <= (b_exp == EXP_ZERO) && (b_frac == 0);

            // Detect infinities
            a_is_inf_s0 <= (a_exp == EXP_INF_NAN) && (a_frac == 0);
            b_is_inf_s0 <= (b_exp == EXP_INF_NAN) && (b_frac == 0);

            // Detect NaNs
            a_is_nan_s0 <= (a_exp == EXP_INF_NAN) && (a_frac != 0);
            b_is_nan_s0 <= (b_exp == EXP_INF_NAN) && (b_frac != 0);

            valid <= 0; // output not ready yet
        end
    end

    // Stage 1: Multiply mantissas and add exponents (minus bias), handle special cases
    always @(posedge clk) begin
        if (rst) begin
            z_sign_s1 <= 0;
            z_exp_s1 <= 0;
            product_s1 <= 0;
            mul_denorm_s1 <= 0;
            special_case_s1 <= 0;
            special_result_s1 <= 0;
        end else begin
            // Calculate sign = xor of input signs
            z_sign_s1 <= a_sign_s0 ^ b_sign_s0;

            // Determine special cases at stage1

            // Propagate NaN if any input is NaN
            if (a_is_nan_s0) begin
                special_case_s1 <= 1'b1;
                // quiet NaN: sign=0, exp=255, frac MSB=1 and rest zero
                special_result_s1 <= {1'b0, 8'hFF, 1'b1, 22'b0};
            end else if (b_is_nan_s0) begin
                special_case_s1 <= 1'b1;
                special_result_s1 <= {1'b0, 8'hFF, 1'b1, 22'b0};
            end
            // Inf * 0 or 0 * Inf => NaN
            else if ((a_is_inf_s0 && b_is_zero_s0) || (b_is_inf_s0 && a_is_zero_s0)) begin
                special_case_s1 <= 1'b1;
                special_result_s1 <= {1'b0, 8'hFF, 1'b1, 22'b0}; // quiet NaN
            end
            // Inf * finite => Inf
            else if (a_is_inf_s0 || b_is_inf_s0) begin
                special_case_s1 <= 1'b1;
                special_result_s1 <= {z_sign_s1, 8'hFF, 23'b0};
            end
            // 0 * finite => 0
            else if (a_is_zero_s0 || b_is_zero_s0) begin
                special_case_s1 <= 1'b1;
                special_result_s1 <= {z_sign_s1, 31'b0};
            end
            else begin
                special_case_s1 <= 1'b0;
                special_result_s1 <= 0;

                // Prepare mantissas for multiplication: add implicit leading 1 for normalized inputs, 0 for denormals
                // Mantissa with leading bit: 24 bits wide
                reg [23:0] a_mantissa_24;
                reg [23:0] b_mantissa_24;

                a_mantissa_24 = (a_exp_s0 == 0) ? {1'b0, a_frac_s0} : {1'b1, a_frac_s0};
                b_mantissa_24 = (b_exp_s0 == 0) ? {1'b0, b_frac_s0} : {1'b1, b_frac_s0};

                // Multiply mantissas
                product_s1 <= a_mantissa_24 * b_mantissa_24; // 24x24=48 bits

                // Add exponents: actual exponent is exp_a + exp_b - bias
                // Use 10-bit to avoid overflow (max sum ~ 254 + 254 - 127 = 381 < 512)
                // For denormals exponent is zero, treat as 1 - bias for proper bias correction
                // But IEEE 754 treats denormals exponent as 1-bias to calculate true exponent.

                reg [9:0] a_exp_adj;
                reg [9:0] b_exp_adj;

                a_exp_adj = (a_exp_s0 == 0) ? 10'd1 : {2'b00, a_exp_s0};
                b_exp_adj = (b_exp_s0 == 0) ? 10'd1 : {2'b00, b_exp_s0};

                z_exp_s1 <= a_exp_adj + b_exp_adj - EXP_BIAS;
                mul_denorm_s1 <= (a_exp_s0 == 0) || (b_exp_s0 == 0);
            end
        end
    end

    // Stage 2: Normalize, round, assemble final result
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
            valid <= 0;
            z_sign_s2 <= 0;
            z_exp_s2 <= 0;
            mantissa_norm_s2 <= 0;
            guard_s2 <= 0; round_s2 <= 0; sticky_s2 <= 0;
            special_case_s2 <= 0;
            special_result_s2 <= 0;
        end else begin
            // Propagate special case info
            special_case_s2 <= special_case_s1;
            special_result_s2 <= special_result_s1;
            z_sign_s2 <= z_sign_s1;
            z_exp_s2 <= z_exp_s1;

            if (special_case_s1) begin
                // Output special case result directly
                z <= special_result_s1;
                valid <= 1;
            end else begin
                // Normalize product mantissa
                // product_s1 is 48 bits. The top bits determine normalization:
                // If bit 47 == 1 => product is normalized: MSB at bit 47
                // Else MSB at bit 46 (shift left by 1 required)

                reg [23:0] mantissa_temp;
                reg guard_bit, round_bit, sticky_bit;
                reg [47:0] product_tmp;
                reg [9:0] exp_temp;

                product_tmp = product_s1;
                exp_temp = z_exp_s1;

                if (product_tmp[47] == 1'b1) begin
                    // normalized, take bits [46:23] as mantissa (24 bits)
                    mantissa_temp = product_tmp[46:23];
                    guard_bit = product_tmp[22];
                    round_bit = product_tmp[21];
                    sticky_bit = |product_tmp[20:0];
                    exp_temp = exp_temp + 1;
                end else begin
                    // shift left by 1
                    mantissa_temp = product_tmp[45:22];
                    guard_bit = product_tmp[21];
                    round_bit = product_tmp[20];
                    sticky_bit = |product_tmp[19:0];
                    // exp_temp stays the same
                end

                // Rounding to nearest even
                // Round up if guard=1 and (round=1 or sticky=1 or LSB=1)
                reg round_increment;
                round_increment = guard_bit && (round_bit || sticky_bit || mantissa_temp[0]);

                {mantissa_temp, exp_temp} = round_increment ? 
                    (mantissa_temp == 24'hFFFFFF ? 
                        {24'h800000, exp_temp + 1} : // mantissa overflow causes right shift, exp +1
                        {mantissa_temp + 1, exp_temp}
                    ) : {mantissa_temp, exp_temp};

                // Handle exponent overflow and underflow
                if (exp_temp[9]) begin
                    // Negative exponent, underflow => zero
                    z <= {z_sign_s2, 31'b0};
                end else if (exp_temp > 10'd254) begin
                    // Overflow => infinity
                    z <= {z_sign_s2, 8'hFF, 23'b0};
                end else if (exp_temp == 10'd0) begin
                    // Subnormal number or zero (flush to zero here)
                    z <= {z_sign_s2, 31'b0};
                end else begin
                    // Normal number
                    // mantissa_temp has leading 1 implicit, so strip it
                    z <= {z_sign_s2, exp_temp[7:0], mantissa_temp[22:0]};
                end
                valid <= 1;
            end
        end
    end

endmodule