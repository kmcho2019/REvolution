module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Stage 0 registers - decode inputs and detect special cases
    reg         s0_sign;
    reg  [7:0]  s0_exp_a, s0_exp_b;
    reg  [22:0] s0_frac_a, s0_frac_b;
    reg  [23:0] s0_mant_a, s0_mant_b;
    reg         s0_zero_a, s0_zero_b;
    reg         s0_inf_a,  s0_inf_b;
    reg         s0_nan_a,  s0_nan_b;

    // Stage 1 registers - multiply mantissas, add exponents, propagate sign and special flags
    reg         s1_sign;
    reg  [8:0]  s1_exp_sum;  // 9 bits enough: max sum ~ 254+1 overflow
    reg  [47:0] s1_product;
    reg         s1_zero_a, s1_zero_b;
    reg         s1_inf_a,  s1_inf_b;
    reg         s1_nan_a,  s1_nan_b;

    // Stage 2 registers - normalize, extract rounding bits, rounding and final assemble
    reg         s2_sign;
    reg  [8:0]  s2_exp;
    reg  [23:0] s2_mant;    // normalized mantissa with leading 1 bit
    reg         s2_guard;
    reg         s2_round;
    reg         s2_sticky;
    reg         s2_zero_a, s2_zero_b;
    reg         s2_inf_a,  s2_inf_b;
    reg         s2_nan_a,  s2_nan_b;

    // Internal signals for rounding and final mantissa, exponent
    reg [24:0] mant_rounded;  // 25 bits: 24 mant + 1 carry
    reg [8:0]  exp_rounded;
    reg        final_sign;
    reg [7:0]  final_exp_8;
    reg [22:0] final_frac;

    // Stage 0: Decode inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s0_sign <= 0;
            s0_exp_a <= 0; s0_exp_b <= 0;
            s0_frac_a <= 0; s0_frac_b <= 0;
            s0_mant_a <= 0; s0_mant_b <= 0;
            s0_zero_a <= 0; s0_zero_b <= 0;
            s0_inf_a <= 0;  s0_inf_b <= 0;
            s0_nan_a <= 0;  s0_nan_b <= 0;
        end else begin
            s0_sign <= a[31] ^ b[31];

            s0_exp_a <= a[30:23];
            s0_exp_b <= b[30:23];
            s0_frac_a <= a[22:0];
            s0_frac_b <= b[22:0];

            s0_zero_a <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            s0_zero_b <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            s0_inf_a  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            s0_inf_b  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            s0_nan_a  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            s0_nan_b  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Add implicit leading 1 for normalized numbers else zero for denormals
            s0_mant_a <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            s0_mant_b <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Stage 1: Multiply mantissas, add exponents, propagate sign and special flags
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_sign <= 0;
            s1_exp_sum <= 0;
            s1_product <= 0;
            s1_zero_a <= 0; s1_zero_b <= 0;
            s1_inf_a  <= 0; s1_inf_b  <= 0;
            s1_nan_a  <= 0; s1_nan_b  <= 0;
        end else begin
            s1_sign <= s0_sign;
            s1_product <= s0_mant_a * s0_mant_b; // 24x24 = 48 bits
            s1_exp_sum <= s0_exp_a + s0_exp_b - EXP_BIAS; // 9-bit to handle overflow
            s1_zero_a <= s0_zero_a; s1_zero_b <= s0_zero_b;
            s1_inf_a  <= s0_inf_a;  s1_inf_b  <= s0_inf_b;
            s1_nan_a  <= s0_nan_a;  s1_nan_b  <= s0_nan_b;
        end
    end

    // Stage 2: Normalize product, extract rounding bits, and prepare for rounding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s2_sign <= 0;
            s2_exp <= 0;
            s2_mant <= 0;
            s2_guard <= 0; s2_round <= 0; s2_sticky <= 0;
            s2_zero_a <= 0; s2_zero_b <= 0;
            s2_inf_a <= 0; s2_inf_b <= 0;
            s2_nan_a <= 0; s2_nan_b <= 0;
        end else begin
            s2_sign <= s1_sign;
            s2_zero_a <= s1_zero_a; s2_zero_b <= s1_zero_b;
            s2_inf_a <= s1_inf_a; s2_inf_b <= s1_inf_b;
            s2_nan_a <= s1_nan_a; s2_nan_b <= s1_nan_b;

            // Normalize:
            // If MSB (bit 47) == 1, product >= 2, shift right by 1, increase exponent
            if (s1_product[47]) begin
                s2_exp <= s1_exp_sum + 9'd1;
                s2_mant <= s1_product[47:24]; // 24 bits with leading 1 included
                s2_guard <= s1_product[23];
                s2_round <= s1_product[22];
                s2_sticky <= |s1_product[21:0];
            end else begin
                s2_exp <= s1_exp_sum;
                s2_mant <= s1_product[46:23];
                s2_guard <= s1_product[22];
                s2_round <= s1_product[21];
                s2_sticky <= |s1_product[20:0];
            end
        end
    end

    // Stage 3: Rounding and output assembly (clocked to reduce combinational delay)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Priority: NaN > Inf * 0 = NaN > Inf > Zero > Normal

            // Combine NaN flag
            if (s2_nan_a || s2_nan_b) begin
                // Return quiet NaN (exponent all 1s, mantissa MSB=1)
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((s2_inf_a && s2_zero_b) || (s2_inf_b && s2_zero_a)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (s2_inf_a || s2_inf_b) begin
                // Infinity times non-zero = infinity
                z <= {s2_sign, 8'hFF, 23'd0};
            end else if (s2_zero_a || s2_zero_b) begin
                // Zero times anything = zero
                z <= {s2_sign, 31'd0};
            end else begin
                // Round to nearest even
                // Determine if we should add one to mantissa
                // round_increment = guard_bit & (round_bit | sticky_bit | LSB_mantissa)
                reg round_increment;
                round_increment = s2_guard & (s2_round | s2_sticky | s2_mant[0]);

                mant_rounded = {1'b0, s2_mant} + (round_increment ? 25'd1 : 25'd0);

                // Handle carry out of mantissa after rounding
                if (mant_rounded[24]) begin
                    // Mantissa overflowed, shift right by 1, increment exponent
                    exp_rounded = s2_exp + 9'd1;
                    final_frac = mant_rounded[24:2]; // shift right 1, drop lowest bit
                end else begin
                    exp_rounded = s2_exp;
                    final_frac = mant_rounded[22:0];
                end

                final_sign = s2_sign;

                // Handle overflow and underflow of exponent
                if (exp_rounded >= 9'd255) begin
                    // Overflow -> Infinity
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (exp_rounded <= 0) begin
                    // Underflow -> flush to zero
                    z <= {final_sign, 31'd0};
                end else begin
                    final_exp_8 = exp_rounded[7:0]; // truncate to 8 bits
                    z <= {final_sign, final_exp_8, final_frac};
                end
            end
        end
    end

endmodule