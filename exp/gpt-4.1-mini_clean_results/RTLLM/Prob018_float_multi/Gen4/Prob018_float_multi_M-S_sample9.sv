module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // IEEE-754 parameters
    localparam EXP_BIAS = 127;

    // States (simple 3-cycle operation)
    localparam S_IDLE    = 2'd0;
    localparam S_CALC    = 2'd1;
    localparam S_OUT     = 2'd2;

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
    reg [9:0] res_exp; // 10 bits to hold exponent sum - bias
    reg [47:0] res_mant_product; // product of 24x24 mantissas

    // Normalized mantissa and exponent after multiplication
    reg [23:0] norm_mant; // includes implicit leading 1
    reg [9:0] norm_exp;
    reg guard, round_bit, sticky;
    reg round_up;

    // Flags for special cases
    reg special_nan, special_inf, special_zero;

    // Temporary rounding values
    reg [24:0] mantissa_rounded;
    reg [9:0] exp_rounded;

    // Sticky bit calculation function: OR of bits below round bit
    function automatic logic sticky_bit_calc(input [20:0] bits);
        sticky_bit_calc = |bits;
    endfunction

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

            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mant <= 0; b_mant <= 0;

            a_exp_zero <= 0; b_exp_zero <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_zero <= 0; b_is_zero <= 0;

            res_sign <= 0;
            res_exp <= 0;
            res_mant_product <= 0;

            norm_mant <= 0;
            norm_exp <= 0;

            guard <= 0; round_bit <= 0; sticky <= 0;
            round_up <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;

            mantissa_rounded <= 0;
            exp_rounded <= 0;
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

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_is_zero <= (a[30:0] == 31'd0);
                    b_is_zero <= (b[30:0] == 31'd0);

                    // Prepare mantissas with implicit leading bit
                    // For denormals (exp=0), leading bit = 0
                    a_mant <= (a_exp_zero) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mant <= (b_exp_zero) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Reset special flags
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;

                    z <= 32'd0; // clear output, will be set in later states
                end

                S_CALC: begin
                    // Check special cases first
                    if (a_is_nan || b_is_nan) begin
                        special_nan <= 1'b1;
                    end else if (a_is_inf || b_is_inf) begin
                        if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero))
                            special_nan <= 1'b1; // Inf * 0 = NaN
                        else
                            special_inf <= 1'b1;
                    end else if (a_is_zero || b_is_zero) begin
                        special_zero <= 1'b1;
                    end else begin
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;
                    end

                    // Compute sign of result
                    res_sign <= a_sign ^ b_sign;

                    // Compute exponent sum with bias adjustment
                    // Treat exponent zero (denormals) as 1 for calculation per IEEE-754
                    res_exp <= (a_exp_zero ? 10'd1 : {2'd0,a_exp}) + (b_exp_zero ? 10'd1 : {2'd0,b_exp}) - EXP_BIAS;

                    // Multiply mantissas (24x24)
                    res_mant_product <= a_mant * b_mant;
                end

                S_OUT: begin
                    if (special_nan) begin
                        // Quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1
                        z <= {1'b0,8'hFF,1'b1,22'd0};
                    end else if (special_inf) begin
                        // Infinity with sign
                        z <= {res_sign, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with sign
                        z <= {res_sign, 31'd0};
                    end else begin
                        // Normal multiplication result path

                        // Normalize product:
                        // If bit 47 is 1, the product is already normalized; exponent +1
                        // Else shift left 1 and exponent unchanged
                        if (res_mant_product[47]) begin
                            norm_mant <= res_mant_product[47:24]; // 24 bits, including leading 1
                            norm_exp <= res_exp + 1;
                            // Extract rounding bits: guard=bit23, round=bit22, sticky=OR bits 21:0
                            guard <= res_mant_product[23];
                            round_bit <= res_mant_product[22];
                            sticky <= |res_mant_product[21:0];
                        end else begin
                            norm_mant <= res_mant_product[46:23]; // shift left by 1
                            norm_exp <= res_exp;
                            guard <= res_mant_product[22];
                            round_bit <= res_mant_product[21];
                            sticky <= |res_mant_product[20:0];
                        end

                        // Round to nearest even:
                        round_up <= guard && (round_bit || sticky || norm_mant[0]);

                        mantissa_rounded = {1'b0, norm_mant} + (round_up ? 25'd1 : 25'd0);
                        exp_rounded = norm_exp;

                        // Handle mantissa overflow after rounding
                        if (mantissa_rounded[24]) begin
                            mantissa_rounded = mantissa_rounded >> 1;
                            exp_rounded = exp_rounded + 1;
                        end

                        // Check for overflow
                        if (exp_rounded >= 10'd255) begin
                            // Overflow to infinity
                            z <= {res_sign, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 0) begin
                            // Underflow to denormal or zero
                            // Calculate right shift amount
                            integer shift_amount;
                            reg [47:0] shifted_mant;
                            reg [22:0] denorm_frac;
                            reg denorm_guard, denorm_round, denorm_sticky;
                            reg denorm_roundup;

                            shift_amount = 1 - exp_rounded;

                            // Prepare mantissa with hidden bit and extend to 48 bits for shifting
                            // mantissa_rounded is 25 bits but highest bit is 0, so leading bit is at bit 23 of norm_mant
                            // Use norm_mant shifted left by 1 to fill 24 bits + 24 zeros = 48 bits
                            shifted_mant = ({1'b0, mantissa_rounded[23:0]} << 24);

                            if (shift_amount < 48)
                                shifted_mant = shifted_mant >> shift_amount;
                            else
                                shifted_mant = 48'd0;

                            denorm_frac = shifted_mant[46:24];
                            denorm_guard = shifted_mant[23];
                            denorm_round = shifted_mant[22];
                            denorm_sticky = |shifted_mant[21:0];

                            denorm_roundup = denorm_guard && (denorm_round || denorm_sticky || denorm_frac[0]);

                            denorm_frac = denorm_frac + (denorm_roundup ? 1 : 0);

                            if (denorm_frac == 0)
                                z <= {res_sign, 31'd0}; // zero
                            else
                                z <= {res_sign, 8'd0, denorm_frac}; // denormal number
                        end else begin
                            // Normal output
                            z <= {res_sign, exp_rounded[7:0], mantissa_rounded[22:0]};
                        end
                    end
                end

            endcase
        end
    end

endmodule