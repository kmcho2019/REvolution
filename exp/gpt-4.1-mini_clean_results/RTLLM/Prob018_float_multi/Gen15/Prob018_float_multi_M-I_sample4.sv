module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Stage 0: Decode inputs and detect special cases
    reg         s0_sign;
    reg  [7:0]  s0_exp_a, s0_exp_b;
    reg  [22:0] s0_frac_a, s0_frac_b;
    reg  [23:0] s0_mant_a, s0_mant_b;
    reg         s0_zero_a, s0_zero_b;
    reg         s0_inf_a,  s0_inf_b;
    reg         s0_nan_a,  s0_nan_b;

    // Stage 1: Multiply mantissas, add exponents, propagate combined special flags
    reg         s1_sign;
    reg  [8:0]  s1_exp_sum;  // 9 bits: exponent sum after bias subtraction
    reg  [47:0] s1_product;

    // Combined special flags to reduce registers
    reg  [5:0]  s1_spec_flags; // bits: 0-zero_a,1-zero_b,2-inf_a,3-inf_b,4-nan_a,5-nan_b

    // Stage 2: Normalize product, prepare rounding bits and propagate special flags
    reg         s2_sign;
    reg  [8:0]  s2_exp;
    reg  [23:0] s2_mant;    // normalized mantissa with leading 1 included
    reg         s2_guard;
    reg         s2_round;
    reg         s2_sticky;
    reg  [5:0]  s2_spec_flags;

    // Stage 3: Rounding, exponent adjustment and output assembly
    reg [24:0] mant_rounded;   // 25 bits for rounding carry
    reg [8:0]  exp_rounded;
    reg        final_sign;
    reg [7:0]  final_exp_8;
    reg [22:0] final_frac;

    // Stage 0: Decode inputs, detect special cases, and prepare mantissas
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s0_sign     <= 1'b0;
            s0_exp_a    <= 8'd0; s0_exp_b <= 8'd0;
            s0_frac_a   <= 23'd0; s0_frac_b <= 23'd0;
            s0_mant_a   <= 24'd0; s0_mant_b <= 24'd0;
            s0_zero_a   <= 1'b0; s0_zero_b <= 1'b0;
            s0_inf_a    <= 1'b0; s0_inf_b <= 1'b0;
            s0_nan_a    <= 1'b0; s0_nan_b <= 1'b0;
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

            // Add implicit leading 1 for normalized numbers; zero for denormals
            s0_mant_a <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            s0_mant_b <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Stage 1: Multiply mantissas (only if neither input zero), add exponents, and combine special flags
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1_sign       <= 1'b0;
            s1_exp_sum    <= 9'd0;
            s1_product    <= 48'd0;
            s1_spec_flags <= 6'd0;
        end else begin
            s1_sign <= s0_sign;

            // Save special flags compactly: zero_a,b, inf_a,b, nan_a,b
            s1_spec_flags[0] <= s0_zero_a;
            s1_spec_flags[1] <= s0_zero_b;
            s1_spec_flags[2] <= s0_inf_a;
            s1_spec_flags[3] <= s0_inf_b;
            s1_spec_flags[4] <= s0_nan_a;
            s1_spec_flags[5] <= s0_nan_b;

            // If either operand zero, product is zero, avoid multiplying unnecessarily
            if (s0_zero_a || s0_zero_b) begin
                s1_product <= 48'd0;
            end else begin
                s1_product <= s0_mant_a * s0_mant_b; // 24x24=48 bit product
            end

            // Exponent sum with bias subtraction (bias added once)
            // Use 9 bits: max exponent sum 254 + 254 -127 = 381 fits in 9 bits
            s1_exp_sum <= s0_exp_a + s0_exp_b - EXP_BIAS;
        end
    end

    // Stage 2: Normalize product, extract rounding bits and propagate special flags
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s2_sign       <= 1'b0;
            s2_exp        <= 9'd0;
            s2_mant       <= 24'd0;
            s2_guard      <= 1'b0;
            s2_round      <= 1'b0;
            s2_sticky     <= 1'b0;
            s2_spec_flags <= 6'd0;
        end else begin
            s2_sign       <= s1_sign;
            s2_spec_flags <= s1_spec_flags;

            // Normalize mantissa:
            // If MSB of product (bit 47) is 1, product >=2, shift right by 1 and increment exponent
            if (s1_product[47]) begin
                s2_exp   <= s1_exp_sum + 9'd1;
                s2_mant  <= s1_product[47:24];  // 24 bits, includes leading 1
                s2_guard <= s1_product[23];
                s2_round <= s1_product[22];
                // Sticky bit from bits [21:6], truncated sticky to 16 bits for power saving
                s2_sticky <= |s1_product[21:6];
            end else begin
                s2_exp   <= s1_exp_sum;
                s2_mant  <= s1_product[46:23];
                s2_guard <= s1_product[22];
                s2_round <= s1_product[21];
                s2_sticky <= |s1_product[20:5];
            end
        end
    end

    // Stage 3: Rounding and final result assembly
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            // Unpack special flags for readability
            wire zero_a = s2_spec_flags[0];
            wire zero_b = s2_spec_flags[1];
            wire inf_a  = s2_spec_flags[2];
            wire inf_b  = s2_spec_flags[3];
            wire nan_a  = s2_spec_flags[4];
            wire nan_b  = s2_spec_flags[5];

            // Handle special cases with IEEE 754 precedence
            if (nan_a || nan_b) begin
                // Quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1, rest zero
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((inf_a && zero_b) || (inf_b && zero_a)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (inf_a || inf_b) begin
                // Infinity times non-zero = Infinity (sign handled)
                z <= {s2_sign, 8'hFF, 23'd0};
            end else if (zero_a || zero_b) begin
                // Zero times anything = zero (sign handled)
                z <= {s2_sign, 31'd0};
            end else begin
                // Normalized number: Round to nearest even
                // round_increment = guard & (round | sticky | LSB_mantissa)
                reg round_increment;
                round_increment = s2_guard & (s2_round | s2_sticky | s2_mant[0]);

                mant_rounded = {1'b0, s2_mant} + (round_increment ? 25'd1 : 25'd0);

                // If carry out of mantissa rounding, shift right and increment exponent
                if (mant_rounded[24]) begin
                    exp_rounded = s2_exp + 9'd1;
                    final_frac  = mant_rounded[24:2]; // shift right by 1
                end else begin
                    exp_rounded = s2_exp;
                    final_frac  = mant_rounded[22:0];
                end

                final_sign = s2_sign;

                // Handle overflow and underflow
                if (exp_rounded >= 9'd255) begin
                    // Overflow to infinity
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (exp_rounded <= 0) begin
                    // Underflow to zero
                    z <= {final_sign, 31'd0};
                end else begin
                    final_exp_8 = exp_rounded[7:0]; // truncate to 8 bits
                    z <= {final_sign, final_exp_8, final_frac};
                end
            end
        end
    end

endmodule