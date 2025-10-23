module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;

    // FSM states
    typedef enum logic [2:0] {
        IDLE,
        DECODE,
        MULTIPLY,
        NORMALIZE,
        ROUND,
        OUTPUT_RESULT
    } state_t;

    state_t state, next_state;

    // Latch inputs at start
    reg [31:0] a_latch, b_latch;

    // Decomposed inputs
    wire a_sign = a_latch[31];
    wire b_sign = b_latch[31];

    wire [7:0] a_exp = a_latch[30:23];
    wire [7:0] b_exp = b_latch[30:23];

    wire [22:0] a_frac = a_latch[22:0];
    wire [22:0] b_frac = b_latch[22:0];

    // Special cases for inputs (combinational)
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Latched signals for each FSM stage
    reg sign_r;
    reg [8:0] exp_sum_r;       // 9-bit for exponent sum after subtracting bias
    reg [47:0] mant_prod_r;    // Product of mantissas (24x24)
    reg zero_a_r, zero_b_r, inf_a_r, inf_b_r, nan_a_r, nan_b_r;

    // Normalization signals
    reg [8:0] exp_norm_r;
    reg [23:0] mant_norm_r;    // Normalized mantissa (24 bits, leading 1 included)
    reg guard_bit_r, round_bit_r, sticky_bit_r;

    // Rounding outputs
    reg [24:0] mant_rounded_r;
    reg [8:0] exp_rounded_r;

    // Sticky bit calculation combinational function
    function automatic logic calc_sticky(input [21:0] bits);
        calc_sticky = |bits;
    endfunction

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            a_latch <= 32'd0;
            b_latch <= 32'd0;
            sign_r <= 1'b0;
            exp_sum_r <= 9'd0;
            mant_prod_r <= 48'd0;
            zero_a_r <= 1'b0; zero_b_r <= 1'b0;
            inf_a_r <= 1'b0; inf_b_r <= 1'b0;
            nan_a_r <= 1'b0; nan_b_r <= 1'b0;
            exp_norm_r <= 9'd0;
            mant_norm_r <= 24'd0;
            guard_bit_r <= 1'b0; round_bit_r <= 1'b0; sticky_bit_r <= 1'b0;
            mant_rounded_r <= 25'd0;
            exp_rounded_r <= 9'd0;
            z <= 32'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    z <= 32'd0;
                    if (1) begin  // Always ready to start on input changes, could add enable signal
                        a_latch <= a;
                        b_latch <= b;
                    end
                end

                DECODE: begin
                    // Latch sign, special flags, mantissa with implicit leading 1 or zero for denormals
                    sign_r <= a_sign ^ b_sign;
                    zero_a_r <= a_zero;
                    zero_b_r <= b_zero;
                    inf_a_r <= a_inf;
                    inf_b_r <= b_inf;
                    nan_a_r <= a_nan;
                    nan_b_r <= b_nan;

                    // Exponent sum with bias adjustment
                    // Use 9 bits to avoid overflow
                    exp_sum_r <= {1'b0,a_exp} + {1'b0,b_exp} - EXP_BIAS;

                    // Prepare mantissas with leading 1 for normalized, else zero for denormals
                    mant_prod_r <= ((a_exp == 8'd0) ? {1'b0,a_frac} : {1'b1,a_frac}) *
                                   ((b_exp == 8'd0) ? {1'b0,b_frac} : {1'b1,b_frac});
                end

                MULTIPLY: begin
                    // Values already latched in DECODE, move forward for normalization
                    // No new calculations needed here; just hold values
                end

                NORMALIZE: begin
                    // Normalize product mantissa:
                    // If MSB (bit 47) == 1, shift right 1 and increment exponent
                    if (mant_prod_r[47]) begin
                        exp_norm_r <= exp_sum_r + 9'd1;
                        mant_norm_r <= mant_prod_r[47:24];
                        guard_bit_r <= mant_prod_r[23];
                        round_bit_r <= mant_prod_r[22];
                        sticky_bit_r <= calc_sticky(mant_prod_r[21:0]);
                    end else begin
                        exp_norm_r <= exp_sum_r;
                        mant_norm_r <= mant_prod_r[46:23];
                        guard_bit_r <= mant_prod_r[22];
                        round_bit_r <= mant_prod_r[21];
                        sticky_bit_r <= calc_sticky(mant_prod_r[20:0]);
                    end
                end

                ROUND: begin
                    // Round to nearest even:
                    // round increment = guard & (round | sticky | lsb)
                    logic round_inc;
                    round_inc = guard_bit_r & (round_bit_r | sticky_bit_r | mant_norm_r[0]);

                    mant_rounded_r <= {1'b0, mant_norm_r} + (round_inc ? 25'd1 : 25'd0);

                    if (mant_rounded_r[24]) begin
                        exp_rounded_r <= exp_norm_r + 9'd1;
                    end else begin
                        exp_rounded_r <= exp_norm_r;
                    end
                end

                OUTPUT_RESULT: begin
                    // Assemble final IEEE-754 result with special case handling

                    // NaN check
                    if (nan_a_r || nan_b_r) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    end
                    else if ((inf_a_r && zero_b_r) || (inf_b_r && zero_a_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end
                    else if (inf_a_r || inf_b_r) begin
                        // Infinity times non-zero
                        z <= {sign_r, 8'hFF, 23'd0};
                    end
                    else if (zero_a_r || zero_b_r) begin
                        // Zero times anything
                        z <= {sign_r, 31'd0};
                    end
                    else begin
                        // Normal result rounding adjustment
                        reg [7:0] final_exp_8;
                        reg [22:0] final_frac;
                        reg [24:0] mant_to_use;

                        if (mant_rounded_r[24]) begin
                            // Mantissa overflow after rounding, shift right one bit
                            mant_to_use = mant_rounded_r >> 1;
                        end else begin
                            mant_to_use = mant_rounded_r;
                        end

                        final_exp_8 = exp_rounded_r[7:0];
                        final_frac = mant_to_use[22:0];

                        // Overflow and underflow handling
                        if (exp_rounded_r >= 9'd255) begin
                            // Overflow to infinity
                            z <= {sign_r, 8'hFF, 23'd0};
                        end else if (exp_rounded_r <= 0) begin
                            // Underflow to zero
                            z <= {sign_r, 31'd0};
                        end else begin
                            z <= {sign_r, final_exp_8, final_frac};
                        end
                    end
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = DECODE;
            DECODE: next_state = MULTIPLY;
            MULTIPLY: next_state = NORMALIZE;
            NORMALIZE: next_state = ROUND;
            ROUND: next_state = OUTPUT_RESULT;
            OUTPUT_RESULT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule