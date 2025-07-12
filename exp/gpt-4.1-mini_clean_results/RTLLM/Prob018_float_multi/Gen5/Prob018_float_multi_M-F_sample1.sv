module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // State encoding
    localparam IDLE   = 3'd0;
    localparam EXTRACT= 3'd1;
    localparam MUL    = 3'd2;
    localparam NORM_RND = 3'd3;
    localparam WRITE  = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    // Pipeline registers between stages

    // Stage EXTRACT: extract sign, exponent, mantissa, detect special cases
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mant, b_mant; // leading one appended if normalized

    reg a_zero, b_zero;
    reg a_inf,  b_inf;
    reg a_nan,  b_nan;

    // Stage MUL: multiply mantissas, add exponents, calculate sign
    reg [49:0] product;        // 24x24 = 48 bits; using 50 bits for alignment
    reg [9:0]  exp_sum;        // extended exponent sum for bias correction and range
    reg        z_sign;

    // Stage NORM_RND: normalize product, prepare rounding bits, round mantissa
    reg [49:0] norm_product;
    reg [9:0]  norm_exp;
    reg        guard_bit, round_bit, sticky_bit;
    reg [23:0] z_mantissa_unrounded;
    reg round_increment;

    // Rounded mantissa and exponent after rounding
    reg [23:0] z_mantissa_rounded;
    reg [9:0]  z_exp_rounded;

    // Special flags for output decision (registered at stage WRITE)
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_inf_by_zero; // inf * 0 = NaN

    // Intermediate result for output multiplexing
    reg [31:0] z_result;

    // Combinational rounding decision and rounding operation
    // This combinational logic is computed after norm_product and rounding bits are registered
    // and before final output.

    // Rounding function: round to nearest even (roundTiesToEven)
    // round_increment = guard_bit & (round_bit | sticky_bit | LSB_of_mantissa)
    wire round_inc_comb;
    wire [24:0] mantissa_with_round; // 25 bits to handle carry
    wire mantissa_overflow_after_round;

    assign round_inc_comb = guard_bit & (round_bit | sticky_bit | z_mantissa_unrounded[0]);
    assign mantissa_with_round = {1'b0, z_mantissa_unrounded} + (round_inc_comb ? 25'd1 : 25'd0);
    assign mantissa_overflow_after_round = mantissa_with_round[24];

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;

            // Reset all pipeline registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mant <= 24'd0; b_mant <= 24'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf  <= 1'b0; b_inf  <= 1'b0;
            a_nan  <= 1'b0; b_nan  <= 1'b0;

            product <= 50'd0;
            exp_sum <= 10'd0;
            z_sign  <= 1'b0;

            norm_product <= 50'd0;
            norm_exp <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            z_mantissa_unrounded <= 24'd0;
            round_increment <= 1'b0;

            z_mantissa_rounded <= 24'd0;
            z_exp_rounded <= 10'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
            special_inf_by_zero <= 1'b0;

            z_result <= 32'd0;
            z <= 32'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    z <= 32'd0; // default output
                end

                EXTRACT: begin
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];
                    // Extract exponents
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

                    // Extract mantissas with implicit leading one if exponent != 0 (normalized)
                    a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
                end

                MUL: begin
                    // Multiply mantissas
                    product <= a_mant * b_mant; // 24x24 -> 48 bits product, stored in 50 bits

                    // Exponent sum with bias adjustment
                    // Using 10 bits to handle overflow and underflow detection
                    exp_sum <= a_exp + b_exp - EXP_BIAS;

                    // Sign of result
                    z_sign <= a_sign ^ b_sign;

                    // Pass special flags for downstream usage
                    special_nan <= a_nan | b_nan;
                    special_inf <= a_inf | b_inf;
                    special_zero <= a_zero | b_zero;
                    // Detect inf*zero = NaN special case
                    special_inf_by_zero <= (a_inf & b_zero) | (b_inf & a_zero);
                end

                NORM_RND: begin
                    // Normalize product:
                    // product is 48 bits, stored in 50-bit reg; use bits [47:0]
                    // If MSB at bit 47 is 1, shift right by 1, increment exponent
                    if (product[47]) begin
                        norm_product <= product >> 1;
                        norm_exp <= exp_sum + 1;
                    end else begin
                        norm_product <= product;
                        norm_exp <= exp_sum;
                    end

                    // Extract rounding bits from normalized product:
                    // Mantissa bits after normalization: bits [46:23]
                    // Guard bit = bit 23
                    // Round bit = bit 22
                    // Sticky bit = OR of bits [21:0]
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];

                    // Unrounded mantissa for rounding decision
                    z_mantissa_unrounded <= product[46:23];

                    round_increment <= 1'b0; // will update combinationally

                end

                WRITE: begin
                    // Perform rounding combinationally based on registered bits
                    // Here update rounded mantissa and exponent
                    // Rounding decision combinationally computed below the always block

                    // If rounding causes mantissa overflow, shift mantissa right by 1 and increment exponent
                    if (mantissa_overflow_after_round) begin
                        z_mantissa_rounded <= mantissa_with_round[24:1];
                        z_exp_rounded <= norm_exp + 1;
                    end else begin
                        z_mantissa_rounded <= mantissa_with_round[23:0];
                        z_exp_rounded <= norm_exp;
                    end

                    // Compose output based on special cases and exponent ranges
                    // We assign the output register 'z_result' combinationally and register it here to 'z'.

                    // Special cases output handled in combinational block below

                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = EXTRACT;
            EXTRACT: next_state = MUL;
            MUL:     next_state = NORM_RND;
            NORM_RND:next_state = WRITE;
            WRITE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Combinational logic for rounding increment signal (for use at WRITE state)
    // We tie rounding inputs to registered signals from NORM_RND state
    // This is done here to avoid blocking assignments and local variables inside sequential always.

    always @(*) begin
        // This combinational block uses registered values from NORM_RND stage
        // to determine rounding increment and output muxing.

        // Defaults for output
        reg [31:0] out;
        out = 32'd0;

        // Round increment logic
        // Guard bit AND (round bit OR sticky bit OR LSB of mantissa)
        // This matches IEEE 754 round to nearest even
        // Note: inputs from registered signals

        // round_inc_comb, mantissa_with_round, mantissa_overflow_after_round are assigned above

        // Compose final output

        if (special_nan) begin
            // NaN: exponent all ones, mantissa nonzero (quiet NaN: MSB of mantissa 1)
            out = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_inf_by_zero) begin
            // Inf * 0 = NaN
            out = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_inf) begin
            // Inf * nonzero = Inf (sign from result)
            out = {z_sign, 8'hFF, 23'd0};
        end else if (special_zero) begin
            // Zero * any = zero (sign from result)
            out = {z_sign, 31'd0};
        end else if (z_exp_rounded >= 8'hFF) begin
            // Overflow to Inf
            out = {z_sign, 8'hFF, 23'd0};
        end else if (z_exp_rounded <= 0) begin
            // Underflow to zero (no subnormal handling for simplicity)
            out = {z_sign, 31'd0};
        end else begin
            // Normalized number output: sign | exponent | mantissa[22:0]
            // Mantissa trimmed to 23 bits (drop implicit leading one)
            out = {z_sign, z_exp_rounded[7:0], z_mantissa_rounded[22:0]};
        end

        z_result = out;
    end

    // Output register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else if (state == WRITE) begin
            z <= z_result;
        end
    end

endmodule