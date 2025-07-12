module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    // IEEE-754 single precision parameters
    localparam EXP_BIAS = 127;

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        LOAD       = 3'd1,
        MULTIPLY   = 3'd2,
        NORMALIZE  = 3'd3,
        ROUND      = 3'd4,
        PACK       = 3'd5,
        DONE       = 3'd6
    } state_t;

    reg [2:0] state, next_state;

    // Registers to hold extracted fields
    reg       a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special cases flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Sign of output
    reg z_sign;

    // Exponent arithmetic using signed 10-bit to accommodate additions/subtractions
    reg signed [9:0] exp_sum;

    // Mantissas with implicit leading 1 for normalized numbers or 0 for denormals
    reg [23:0] a_mant, b_mant;

    // Registers for iterative multiplication
    reg [47:0] product; // 48-bit product register (accumulator)
    reg [23:0] multiplier; // Multiplier mantissa (b_mant)
    reg [4:0]  mul_counter; // Counts 0 to 23 for 24 bits

    // Normalized mantissa after multiplication (24 bits), normalization shift count
    reg [47:0] norm_product;
    reg [5:0]  norm_shift;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [23:0] rounded_mant;
    reg signed [9:0] rounded_exp;

    // Sticky bit calculation helper
    wire sticky_part;
    assign sticky_part = |norm_product[0:21]; // lower bits for sticky

    // Multiplication done flag
    wire mul_done = (mul_counter == 5'd24);

    // ================================
    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;
        end else begin
            state <= next_state;
        end
    end

    // ================================
    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = LOAD;
            LOAD:    next_state = (a_is_nan || b_is_nan || a_is_inf || b_is_inf || a_is_zero || b_is_zero) ? PACK : MULTIPLY;
            MULTIPLY: next_state = mul_done ? NORMALIZE : MULTIPLY;
            NORMALIZE: next_state = ROUND;
            ROUND:   next_state = PACK;
            PACK:    next_state = DONE;
            DONE:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // ================================
    // Main sequential datapath logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            z_sign <= 0;
            exp_sum <= 0;
            a_mant <= 0; b_mant <= 0;
            product <= 0;
            multiplier <= 0;
            mul_counter <= 0;
            norm_product <= 0;
            norm_shift <= 0;
            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            rounded_mant <= 0;
            rounded_exp <= 0;
            z <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Do nothing, wait
                    z <= 32'd0;
                end
                LOAD: begin
                    // Extract fields from a and b
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp  <= a[30:23];
                    b_exp  <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);

                    // Determine output sign
                    z_sign <= a[31] ^ b[31];

                    // Prepare mantissas (implicit leading 1 for normal, else zero)
                    a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Calculate exponent sum with bias correction (a_exp + b_exp - bias)
                    exp_sum <= $signed({1'b0, a[30:23]}) + $signed({1'b0, b[30:23]}) - EXP_BIAS;

                    // Reset multiplier state
                    product <= 48'd0;
                    multiplier <= b_mant;
                    mul_counter <= 0;

                    // Reset normalization and rounding registers
                    norm_product <= 0;
                    norm_shift <= 0;
                    guard_bit <= 0;
                    round_bit <= 0;
                    sticky_bit <= 0;
                    rounded_mant <= 0;
                    rounded_exp <= 0;
                end

                MULTIPLY: begin
                    // Iterative shift-add multiplication of a_mant * multiplier

                    // At each cycle, check LSB of multiplier, add a_mant shifted if LSB=1
                    if (multiplier[0]) begin
                        product <= product + (a_mant << mul_counter);
                    end

                    // Shift multiplier right by 1 for next bit
                    multiplier <= multiplier >> 1;

                    // Increment multiplication bit counter
                    mul_counter <= mul_counter + 1'b1;
                end

                NORMALIZE: begin
                    // Normalization step after multiplication done

                    norm_product <= product;

                    // Determine if MSB is set at bit 47 (indexing from 0)
                    // If MSB set, no normalization shift needed, else shift left until MSB set
                    if (product[47]) begin
                        // No shift needed, exponent incremented by 1 because product is effectively 48 bits (24x24),
                        // top 2 bits used for normalization as in typical floating multiplication
                        norm_shift <= 0;
                        rounded_exp <= exp_sum + 1;
                    end else begin
                        // Need to shift left until MSB at bit 46 or below shifts to bit 47
                        // Count leading zeros starting from bit 46 downwards to bit 23 (mantissa bits)
                        // For performance in hardware, a loop or priority encoder is needed; here we do simple approach:

                        integer i;
                        norm_shift = 0;
                        for (i = 46; i >= 23; i=i-1) begin
                            if (!product[i])
                                norm_shift = norm_shift + 1;
                            else
                                break;
                        end

                        norm_product <= product << norm_shift;
                        rounded_exp <= exp_sum - norm_shift;
                    end

                    // Extract mantissa bits: bits [46:24] or [47:25] depending on normalization
                    // We'll always take bits [46:24] after normalization shift
                    // Guard bit = bit 23
                    // Round bit = bit 22
                    // Sticky bit = OR of bits 21 down to 0

                    // Normalize mantissa bits to 24 bits
                    rounded_mant <= norm_product[46:23];

                    guard_bit <= norm_product[22];
                    round_bit <= norm_product[21];
                    sticky_bit <= |norm_product[20:0];
                end

                ROUND: begin
                    // Round to nearest even
                    // Round increment condition:
                    // If guard bit = 1 and (round bit or sticky bit or LSB of mantissa is 1), add 1

                    reg round_inc;
                    round_inc = guard_bit & (round_bit | sticky_bit | rounded_mant[0]);

                    if (round_inc) begin
                        // Add 1 to mantissa
                        rounded_mant <= rounded_mant + 1;
                        // Check mantissa overflow after rounding (i.e. 24'b1_1111_1111_1111_1111_1111_1111 + 1)
                        if (rounded_mant == 24'hFFFFFF) begin
                            // Overflowed, shift mantissa right and increment exponent
                            rounded_mant <= rounded_mant >> 1;
                            rounded_exp <= rounded_exp + 1;
                        end
                    end
                end

                PACK: begin
                    // Pack final result into IEEE 754 format, handling special cases

                    // Priority:
                    // 1) NaN if any input NaN
                    // 2) Inf * 0 = NaN
                    // 3) Inf * nonzero = Inf
                    // 4) zero * any = zero
                    // 5) Normal numbers with overflow/underflow checks

                    if (a_is_nan || b_is_nan) begin
                        // Quiet NaN: sign=0, exp=255, mantissa MSB=1 and rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf times non-zero or Inf*Inf = Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero times anything = zero with sign
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal numbers output
                        // Check for exponent overflow
                        if (rounded_exp >= 255) begin
                            // Overflow: set to Inf
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (rounded_exp <= 0) begin
                            // Underflow: flush to zero (no gradual underflow)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normalized result
                            z <= {z_sign, rounded_exp[7:0], rounded_mant[22:0]};
                        end
                    end
                end

                DONE: begin
                    // Hold output stable, can wait for new inputs or reset
                end

                default: begin
                    // default no action
                end
            endcase
        end
    end

endmodule