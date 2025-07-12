module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Cycle counter for pipeline control (0-3)
    reg [1:0] counter;

    // Stage 0 registers: input extraction and classification
    reg         a_sign_s0, b_sign_s0;
    reg [7:0]   a_exp_s0, b_exp_s0;
    reg [22:0]  a_frac_s0, b_frac_s0;

    reg         a_is_zero_s0, b_is_zero_s0;
    reg         a_is_inf_s0,  b_is_inf_s0;
    reg         a_is_nan_s0,  b_is_nan_s0;

    reg [23:0]  a_mant_s0, b_mant_s0;
    reg         sign_s0;

    // Stage 1 registers: multiplication and exponent addition
    reg [47:0]  product_s1;
    reg [9:0]   exp_sum_s1;       // wider than 8 bits for overflow detection
    reg         sign_s1;
    reg         a_is_zero_s1, b_is_zero_s1;
    reg         a_is_inf_s1,  b_is_inf_s1;
    reg         a_is_nan_s1,  b_is_nan_s1;

    // Stage 2 registers: normalization and rounding bits extraction
    reg [47:0]  product_s2;
    reg [9:0]   exp_norm_s2;
    reg         sign_s2;
    reg         a_is_zero_s2, b_is_zero_s2;
    reg         a_is_inf_s2,  b_is_inf_s2;
    reg         a_is_nan_s2,  b_is_nan_s2;

    reg [23:0]  mant_norm_s2; // 24-bit mantissa with leading 1 explicit
    reg         guard_s2, round_s2, sticky_s2;

    // Stage 3 registers: rounding and output assembly
    reg [23:0]  mant_round_s3;
    reg [9:0]   exp_round_s3;
    reg         sign_s3;
    reg         a_is_zero_s3, b_is_zero_s3;
    reg         a_is_inf_s3,  b_is_inf_s3;
    reg         a_is_nan_s3,  b_is_nan_s3;

    reg         round_increment_s3;

    // Intermediate registers declared at module level to avoid synthesis errors
    reg [24:0] mant_rounded;   // 25-bit to detect carry after rounding
    reg [7:0]  final_exp;
    reg        final_sign;
    reg [22:0] final_mant;

    // Cycle 0: Input decode, classification, prepare mantissas and sign
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;

            a_sign_s0 <= 0; b_sign_s0 <= 0;
            a_exp_s0 <= 0; b_exp_s0 <= 0;
            a_frac_s0 <= 0; b_frac_s0 <= 0;

            a_is_zero_s0 <= 0; b_is_zero_s0 <= 0;
            a_is_inf_s0 <= 0; b_is_inf_s0 <= 0;
            a_is_nan_s0 <= 0; b_is_nan_s0 <= 0;

            a_mant_s0 <= 0; b_mant_s0 <= 0;
            sign_s0 <= 0;

            z <= 32'd0;
        end else begin
            case (counter)
                2'd0: begin
                    // Extract sign, exponent, fraction fields
                    a_sign_s0 <= a[31];
                    b_sign_s0 <= b[31];

                    a_exp_s0 <= a[30:23];
                    b_exp_s0 <= b[30:23];

                    a_frac_s0 <= a[22:0];
                    b_frac_s0 <= b[22:0];

                    // Detect special cases: zero, inf, NaN
                    a_is_zero_s0 <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero_s0 <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf_s0 <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf_s0 <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan_s0 <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan_s0 <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit leading 1 if normalized, else zero for denormals
                    a_mant_s0 <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant_s0 <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Sign of result is XOR of inputs
                    sign_s0 <= a[31] ^ b[31];

                    counter <= 2'd1;
                end

                // Stage 1, 2, 3 handled below
                default: counter <= counter + 1'b1;
            endcase
        end
    end

    // Stage 1: Mantissa multiplication and exponent addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s1 <= 0;
            exp_sum_s1 <= 0;
            sign_s1 <= 0;
            a_is_zero_s1 <= 0; b_is_zero_s1 <= 0;
            a_is_inf_s1 <= 0; b_is_inf_s1 <= 0;
            a_is_nan_s1 <= 0; b_is_nan_s1 <= 0;
        end else if (counter == 2'd1) begin
            product_s1 <= a_mant_s0 * b_mant_s0; // 24x24 multiplication = 48 bits

            // Exponent sum = a_exp + b_exp - bias
            exp_sum_s1 <= a_exp_s0 + b_exp_s0 - EXP_BIAS;

            sign_s1 <= sign_s0;

            // Propagate special cases
            a_is_zero_s1 <= a_is_zero_s0; b_is_zero_s1 <= b_is_zero_s0;
            a_is_inf_s1 <= a_is_inf_s0; b_is_inf_s1 <= b_is_inf_s0;
            a_is_nan_s1 <= a_is_nan_s0; b_is_nan_s1 <= b_is_nan_s0;
        end
    end

    // Stage 2: Normalization and rounding bit extraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_s2 <= 0;
            exp_norm_s2 <= 0;
            sign_s2 <= 0;
            a_is_zero_s2 <= 0; b_is_zero_s2 <= 0;
            a_is_inf_s2 <= 0; b_is_inf_s2 <= 0;
            a_is_nan_s2 <= 0; b_is_nan_s2 <= 0;
            mant_norm_s2 <= 0;
            guard_s2 <= 0;
            round_s2 <= 0;
            sticky_s2 <= 0;
        end else if (counter == 2'd2) begin
            // Propagate inputs
            product_s2 <= product_s1;
            exp_norm_s2 <= exp_sum_s1;
            sign_s2 <= sign_s1;

            a_is_zero_s2 <= a_is_zero_s1; b_is_zero_s2 <= b_is_zero_s1;
            a_is_inf_s2 <= a_is_inf_s1; b_is_inf_s2 <= b_is_inf_s1;
            a_is_nan_s2 <= a_is_nan_s1; b_is_nan_s2 <= b_is_nan_s1;

            // Normalize product:
            // If MSB (bit 47) == 1, product >= 2.0, shift right by 1 and increment exponent.
            if (product_s1[47]) begin
                mant_norm_s2 <= product_s1[47:24]; // 24 bits with leading 1 included
                exp_norm_s2 <= exp_sum_s1 + 10'd1;
                guard_s2 <= product_s1[23];
                round_s2 <= product_s1[22];
                sticky_s2 <= |product_s1[21:0];
            end else begin
                mant_norm_s2 <= product_s1[46:23]; // shifted mantissa
                exp_norm_s2 <= exp_sum_s1;
                guard_s2 <= product_s1[22];
                round_s2 <= product_s1[21];
                sticky_s2 <= |product_s1[20:0];
            end
        end
    end

    // Stage 3: Rounding, exponent adjustment, special cases, output assembly
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mant_round_s3 <= 0;
            exp_round_s3 <= 0;
            sign_s3 <= 0;
            a_is_zero_s3 <= 0; b_is_zero_s3 <= 0;
            a_is_inf_s3 <= 0; b_is_inf_s3 <= 0;
            a_is_nan_s3 <= 0; b_is_nan_s3 <= 0;
            round_increment_s3 <= 0;
            mant_rounded <= 0;
            final_exp <= 0;
            final_sign <= 0;
            final_mant <= 0;
            z <= 0;
        end else if (counter == 2'd3) begin
            // Propagate signals
            mant_round_s3 <= mant_norm_s2;
            exp_round_s3 <= exp_norm_s2;
            sign_s3 <= sign_s2;

            a_is_zero_s3 <= a_is_zero_s2; b_is_zero_s3 <= b_is_zero_s2;
            a_is_inf_s3 <= a_is_inf_s2; b_is_inf_s3 <= b_is_inf_s2;
            a_is_nan_s3 <= a_is_nan_s2; b_is_nan_s3 <= b_is_nan_s2;

            // Rounding decision: round to nearest even
            // Round increment if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)
            round_increment_s3 <= (guard_s2 && (round_s2 | sticky_s2 | mant_norm_s2[0]));

            if (round_increment_s3)
                mant_rounded <= {1'b0, mant_norm_s2} + 25'd1;
            else
                mant_rounded <= {1'b0, mant_norm_s2};

            // Handle mantissa overflow after rounding (carry out)
            if (mant_rounded[24]) begin
                // Mantissa overflow: shift right by 1 and increment exponent
                final_exp <= exp_round_s3[7:0] + 8'd1;
                final_mant <= mant_rounded[24:2]; // drop LSB after shift (shift right 1)
            end else begin
                final_exp <= exp_round_s3[7:0];
                final_mant <= mant_rounded[22:0];
            end
            final_sign <= sign_s3;

            // Special cases handling with priority:
            if (a_is_nan_s3 || b_is_nan_s3) begin
                // Quiet NaN: exponent all ones and mantissa with MSB=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf_s3 && b_is_zero_s3) || (b_is_inf_s3 && a_is_zero_s3)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf_s3 || b_is_inf_s3) begin
                // Inf times non-zero = Inf
                z <= {final_sign, 8'hFF, 23'd0};
            end else if (a_is_zero_s3 || b_is_zero_s3) begin
                // Zero times anything = Zero
                z <= {final_sign, 31'd0};
            end else begin
                // Normal numbers: check exponent overflow/underflow
                if (final_exp >= 8'hFF) begin
                    // Overflow -> Infinity
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (final_exp <= 0) begin
                    // Underflow -> Zero (flush to zero)
                    z <= {final_sign, 31'd0};
                end else begin
                    // Normal case: assemble float sign | exponent | mantissa
                    z <= {final_sign, final_exp, final_mant};
                end
            end
        end
    end

endmodule