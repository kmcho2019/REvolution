module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // IEEE-754 single-precision parameters
    localparam EXP_BIAS = 127;

    // States (simple 3-cycle operation)
    localparam S_IDLE = 2'd0;
    localparam S_CALC = 2'd1;
    localparam S_OUT  = 2'd2;

    reg [1:0] state, next_state;

    // Input decomposition registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg [23:0] a_mant, b_mant; // mantissa with implicit leading 1 or 0 for denormals
    reg a_exp_zero, b_exp_zero;
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Intermediate signals
    reg res_sign;
    reg signed [9:0] res_exp; // 10 bits signed to hold exponent sum - bias
    reg [47:0] res_mant_product; // product of 24x24 mantissas

    // Normalized mantissa and exponent after multiplication
    reg [23:0] norm_mant; // includes implicit leading 1
    reg signed [9:0] norm_exp;
    reg guard, round_bit, sticky;
    reg round_up;

    // Flags for special cases
    reg special_nan, special_inf, special_zero;

    // Rounded mantissa and exponent
    reg [24:0] mantissa_rounded; // 25 bits to hold rounded mantissa + carry
    reg signed [9:0] exp_rounded;

    // Sticky bit calculation function: OR of bits below round bit (unused as function)
    // function automatic logic sticky_bit_calc(input [20:0] bits);
    //     sticky_bit_calc = |bits;
    // endfunction

    // State transition logic
    always @(*) begin
        case(state)
            S_IDLE:  next_state = S_CALC;
            S_CALC:  next_state = S_OUT;
            S_OUT:   next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            z <= 32'd0;

            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mant <= 24'd0; b_mant <= 24'd0;

            a_exp_zero <= 1'b0; b_exp_zero <= 1'b0;
            a_is_nan <= 1'b0; b_is_nan <= 1'b0;
            a_is_inf <= 1'b0; b_is_inf <= 1'b0;
            a_is_zero <= 1'b0; b_is_zero <= 1'b0;

            res_sign <= 1'b0;
            res_exp <= 10'sd0;
            res_mant_product <= 48'd0;

            norm_mant <= 24'd0;
            norm_exp <= 10'sd0;

            guard <= 1'b0; round_bit <= 1'b0; sticky <= 1'b0;
            round_up <= 1'b0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;

            mantissa_rounded <= 25'd0;
            exp_rounded <= 10'sd0;
        end else begin
            state <= next_state;

            case(state)
                S_IDLE: begin
                    // Decompose inputs
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_exp_zero <= (a[30:23] == 8'd0);
                    b_exp_zero <= (b[30:23] == 8'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);

                    a_is_inf <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                    b_is_inf <= (b[30:23] == 8'hFF) && (~|b[22:0]);

                    // Zero detection: exponent zero and mantissa zero
                    a_is_zero <= (a[30:0] == 31'd0);
                    b_is_zero <= (b[30:0] == 31'd0);

                    // Prepare mantissas with implicit leading bit
                    // For denormals (exp=0), leading bit = 0
                    a_mant <= (a_exp_zero) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mant <= (b_exp_zero) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Reset special flags every cycle so they remain stable throughout
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;

                    // Clear output early for safe default
                    z <= 32'd0;
                end

                S_CALC: begin
                    // Determine special cases and set flags, stable through this cycle and next
                    if (a_is_nan || b_is_nan) begin
                        special_nan <= 1'b1;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;
                    end else if (a_is_inf || b_is_inf) begin
                        if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                            special_nan <= 1'b1; // Inf * 0 = NaN
                            special_inf <= 1'b0;
                            special_zero <= 1'b0;
                        end else begin
                            special_inf <= 1'b1;
                            special_nan <= 1'b0;
                            special_zero <= 1'b0;
                        end
                    end else if (a_is_zero || b_is_zero) begin
                        special_zero <= 1'b1;
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                    end else begin
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;
                    end

                    // Compute sign of result
                    res_sign <= a_sign ^ b_sign;

                    // Exponent calculation:
                    // For denormals (exp=0), treat exponent as 1 for calculation (per IEEE-754)
                    // Use signed arithmetic to handle underflow properly
                    res_exp <= (a_exp_zero ? 10'sd1 : {2'd0, a_exp}) + (b_exp_zero ? 10'sd1 : {2'd0, b_exp}) - EXP_BIAS;

                    // Multiply mantissas (24x24)
                    res_mant_product <= a_mant * b_mant;
                end

                S_OUT: begin
                    // Maintain special flags stable
                    // special_nan, special_inf, special_zero set in previous cycle (S_CALC)

                    if (special_nan) begin
                        // Quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1, others zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity with sign
                        z <= {res_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with sign (including negative zero)
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Normal multiplication result

                        // Normalize product:
                        // If bit 47 is 1, product normalized, exponent +1
                        // Else shift left 1, exponent unchanged
                        if (res_mant_product[47]) begin
                            norm_mant <= res_mant_product[47:24]; // 24 bits, leading 1 included
                            norm_exp <= res_exp + 1;

                            guard <= res_mant_product[23];
                            round_bit <= res_mant_product[22];
                            sticky <= |res_mant_product[21:0];
                        end else begin
                            norm_mant <= res_mant_product[46:23]; // shifted left 1
                            norm_exp <= res_exp;

                            guard <= res_mant_product[22];
                            round_bit <= res_mant_product[21];
                            sticky <= |res_mant_product[20:0];
                        end

                        // Round to nearest even:
                        // Round up if guard=1 and (round_bit=1 or sticky=1 or LSB of mantissa=1)
                        round_up <= guard && (round_bit || sticky || norm_mant[0]);

                        // Add round bit
                        mantissa_rounded <= {1'b0, norm_mant} + (round_up ? 25'd1 : 25'd0);
                        exp_rounded <= norm_exp;

                        // Handle mantissa overflow after rounding
                        // If MSB of mantissa_rounded is 1, shift right by 1 and increment exponent
                        if (mantissa_rounded[24]) begin
                            mantissa_rounded <= mantissa_rounded >> 1;
                            exp_rounded <= exp_rounded + 1;
                        end

                        // Check for overflow (exponent too large)
                        if (exp_rounded >= 10'sd255) begin
                            // Overflow => infinity
                            z <= {res_sign, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 0) begin
                            // Underflow: convert to denormal or zero
                            // Calculate right shift amount for mantissa to create denormal
                            integer shift_amount;
                            reg [47:0] shifted_mant;
                            reg [22:0] denorm_frac;
                            reg denorm_guard, denorm_round, denorm_sticky;
                            reg denorm_roundup;
                            reg [24:0] mantissa_ext;

                            // Prepare mantissa with implicit leading 1 (normalized mantissa_rounded[23:0]) shifted up to 48 bits
                            // mantissa_rounded[23:0] holds mantissa including implicit leading 1 bit (bit 23)
                            mantissa_ext = mantissa_rounded;

                            // Shift mantissa to 48-bit space aligned at bit 47
                            shifted_mant = {mantissa_ext, 23'd0}; // 25 + 23 = 48 bits, MSB at bit 47

                            shift_amount = 1 - exp_rounded;

                            if (shift_amount < 48)
                                shifted_mant = shifted_mant >> shift_amount;
                            else
                                shifted_mant = 48'd0;

                            denorm_frac = shifted_mant[46:24]; // 23 bits mantissa fraction
                            denorm_guard = shifted_mant[23];
                            denorm_round = shifted_mant[22];
                            denorm_sticky = |shifted_mant[21:0];

                            denorm_roundup = denorm_guard && (denorm_round || denorm_sticky || denorm_frac[0]);

                            denorm_frac = denorm_frac + (denorm_roundup ? 1 : 0);

                            // If increment causes mantissa to overflow, shift right and handle zero case
                            if (denorm_frac == 0) begin
                                // Output zero
                                z <= {res_sign, 31'd0};
                            end else begin
                                // Denormalized number: exponent = 0
                                z <= {res_sign, 8'd0, denorm_frac};
                            end
                        end else begin
                            // Normal output (exponent > 0 and < 255)
                            z <= {res_sign, exp_rounded[7:0], mantissa_rounded[22:0]};
                        end
                    end
                end
            endcase
        end
    end

endmodule