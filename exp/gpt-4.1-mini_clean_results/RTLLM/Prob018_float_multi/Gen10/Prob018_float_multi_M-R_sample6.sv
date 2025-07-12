module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // Constants
    localparam EXP_BIAS = 127;

    // State machine states
    typedef enum reg [2:0] {
        IDLE        = 3'd0,
        DECODE      = 3'd1,
        MULTIPLY    = 3'd2,
        NORMALIZE   = 3'd3,
        ROUND       = 3'd4,
        OUTPUT      = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Inputs decoded fields
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 or zero for denormals
    reg [23:0] a_mant, b_mant;

    // Product and intermediate signals
    reg [47:0] product;         // 24x24 product
    reg [8:0]  exp_sum;         // exponent sum with overflow bit
    reg        sign_prod;

    // Normalized mantissa and exponent before rounding
    reg [23:0] norm_mant;
    reg [8:0]  norm_exp;

    reg        guard_bit;
    reg        round_bit;
    reg        sticky_bit;

    // Rounding result signals
    reg [24:0] mantissa_rounded; // 25 bits to handle carry
    reg [8:0]  exp_rounded;
    reg        final_sign;
    reg [7:0]  final_exp_8;
    reg [22:0] final_frac;

    // Special case flags latched for output stage
    reg nan_flag;
    reg inf_flag;
    reg zero_flag;

    // Sticky bit calculation helper function (combinational)
    function automatic logic calc_sticky(input [20:0] bits);
        integer i;
        begin
            calc_sticky = 1'b0;
            for (i = 0; i < 21; i = i+1) begin
                if (bits[i]) calc_sticky = 1'b1;
            end
        end
    endfunction

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:       next_state = DECODE;
            DECODE:     next_state = MULTIPLY;
            MULTIPLY:   next_state = NORMALIZE;
            NORMALIZE:  next_state = ROUND;
            ROUND:      next_state = OUTPUT;
            OUTPUT:     next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;
            // Clear all registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mant <= 24'd0; b_mant <= 24'd0;
            product <= 48'd0;
            exp_sum <= 9'd0;
            sign_prod <= 1'b0;
            norm_mant <= 24'd0;
            norm_exp <= 9'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exp_rounded <= 9'd0;
            final_sign <= 1'b0;
            final_exp_8 <= 8'd0;
            final_frac <= 23'd0;
            nan_flag <= 1'b0;
            inf_flag <= 1'b0;
            zero_flag <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Hold output zero until start
                    z <= 32'd0;
                end

                DECODE: begin
                    // Extract sign, exponent, fraction
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp  <= a[30:23];
                    b_exp  <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Prepare mantissas with implicit leading 1 for normalized
                    a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                MULTIPLY: begin
                    // Compute sign
                    sign_prod <= a_sign ^ b_sign;

                    // Multiply mantissas
                    product <= a_mant * b_mant;

                    // Sum exponents subtract bias (use 9 bits for overflow)
                    exp_sum <= a_exp + b_exp - EXP_BIAS;

                    // Latch special flags for output stage
                    nan_flag <= a_nan || b_nan;
                    inf_flag <= (a_inf || b_inf) && !(a_zero || b_zero);
                    zero_flag <= a_zero || b_zero;
                end

                NORMALIZE: begin
                    // Normalize product:
                    // If MSB (bit 47) set, shift right by 1 and increment exponent
                    if (product[47]) begin
                        norm_exp  <= exp_sum + 9'd1;
                        norm_mant <= product[47:24];
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        norm_exp  <= exp_sum;
                        norm_mant <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                ROUND: begin
                    // Round to nearest even
                    // round_increment = guard & (round | sticky | LSB mantissa)
                    reg round_inc;
                    round_inc = guard_bit & (round_bit | sticky_bit | norm_mant[0]);

                    mantissa_rounded <= {1'b0, norm_mant} + (round_inc ? 25'd1 : 25'd0);

                    // Handle mantissa overflow after rounding
                    if (mantissa_rounded[24]) begin
                        exp_rounded <= norm_exp + 9'd1;
                    end else begin
                        exp_rounded <= norm_exp;
                    end
                    final_sign <= sign_prod;
                end

                OUTPUT: begin
                    // Final mantissa bits after possible shift due to rounding overflow
                    if (mantissa_rounded[24]) begin
                        final_frac <= mantissa_rounded[24:2]; // shifted right by 1, drop LSB
                    end else begin
                        final_frac <= mantissa_rounded[22:0];
                    end

                    // Handle overflow and underflow
                    if (nan_flag) begin
                        // Quiet NaN (exponent all 1s, MSB mantissa=1)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((inf_flag && zero_flag)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (inf_flag) begin
                        // Infinity * non-zero
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (zero_flag) begin
                        // Zero * anything
                        z <= {final_sign, 31'd0};
                    end else if (exp_rounded >= 9'd255) begin
                        // Overflow -> infinity
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (exp_rounded <= 0) begin
                        // Underflow -> zero (flush)
                        z <= {final_sign, 31'd0};
                    end else begin
                        final_exp_8 <= exp_rounded[7:0];
                        z <= {final_sign, final_exp_8, final_frac};
                    end
                end

                default: begin
                    // Default hold output
                    z <= z;
                end
            endcase
        end
    end

endmodule