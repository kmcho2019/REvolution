module float_multi(
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] z
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        DECODE     = 3'd1,
        MUL        = 3'd2,
        NORMALIZE  = 3'd3,
        ROUND      = 3'd4,
        PACK       = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Input fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Expanded mantissas with implicit leading bit or zero for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate registers
    reg signed [9:0] exponent_sum; // 10 bits signed to hold exponent arithmetic safely
    reg z_sign_reg;

    reg [47:0] product; // 24 x 24 multiplier result

    // Normalized mantissa and exponent before rounding
    reg [23:0] norm_mantissa;
    reg signed [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [23:0] rounded_mantissa;
    reg signed [9:0] rounded_exponent;

    // Special case signals (combinational)
    wire a_is_nan, b_is_nan, a_is_inf, b_is_inf, a_is_zero, b_is_zero;
    wire inf_zero_case;
    wire is_nan, is_inf, is_zero;

    // Extract fields combinationally from inputs (for special case detection)
    wire [7:0] a_exp_wire = a[30:23];
    wire [7:0] b_exp_wire = b[30:23];
    wire [22:0] a_frac_wire = a[22:0];
    wire [22:0] b_frac_wire = b[22:0];
    wire a_sign_wire = a[31];
    wire b_sign_wire = b[31];

    // Special cases detection combinational logic
    assign a_is_nan   = (a_exp_wire == 8'hFF) && (|a_frac_wire);
    assign b_is_nan   = (b_exp_wire == 8'hFF) && (|b_frac_wire);
    assign a_is_inf   = (a_exp_wire == 8'hFF) && (~|a_frac_wire);
    assign b_is_inf   = (b_exp_wire == 8'hFF) && (~|b_frac_wire);
    assign a_is_zero  = (a_exp_wire == 8) && (~|a_frac_wire);
    assign b_is_zero  = (b_exp_wire == 8) && (~|b_frac_wire);

    assign inf_zero_case = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    assign is_nan  = a_is_nan || b_is_nan || inf_zero_case;
    assign is_inf  = ((a_is_inf || b_is_inf) && ~inf_zero_case);
    assign is_zero = ((a_is_zero || b_is_zero) && ~is_nan && ~is_inf);

    // State machine sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // State transitions and sequential logic
    always @(posedge clk) begin
        if (rst) begin
            // Clear all internal registers
            a_sign     <= 1'b0;
            b_sign     <= 1'b0;
            a_exp      <= 8'd0;
            b_exp      <= 8'd0;
            a_frac     <= 23'd0;
            b_frac     <= 23'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            exponent_sum <= 10'sd0;
            product    <= 48'd0;
            z_sign_reg <= 1'b0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'sd0;
            guard_bit  <= 1'b0;
            round_bit  <= 1'b0;
            sticky_bit <= 1'b0;
            rounded_mantissa <= 24'd0;
            rounded_exponent <= 10'sd0;
            z          <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Output zero while idle
                    z <= 32'd0;
                end

                DECODE: begin
                    // Latch inputs and decode fields
                    a_sign <= a_sign_wire;
                    b_sign <= b_sign_wire;
                    a_exp  <= a_exp_wire;
                    b_exp  <= b_exp_wire;
                    a_frac <= a_frac_wire;
                    b_frac <= b_frac_wire;

                    // Prepare mantissas with implicit leading 1 for normal numbers or 0 for denormals
                    a_mantissa <= (a_exp_wire == 8'd0) ? {1'b0, a_frac_wire} : {1'b1, a_frac_wire};
                    b_mantissa <= (b_exp_wire == 8'd0) ? {1'b0, b_frac_wire} : {1'b1, b_frac_wire};

                    // Compute sign of result
                    z_sign_reg <= a_sign_wire ^ b_sign_wire;

                    // Calculate exponent sum minus bias 127, as signed
                    exponent_sum <= $signed({2'b00, a_exp_wire}) + $signed({2'b00, b_exp_wire}) - 10'sd127;

                    // Clear product and others for safety
                    product <= 48'd0;
                    norm_mantissa <= 24'd0;
                    norm_exponent <= 10'sd0;
                    guard_bit <= 1'b0;
                    round_bit <= 1'b0;
                    sticky_bit <= 1'b0;
                    rounded_mantissa <= 24'd0;
                    rounded_exponent <= 10'sd0;
                end

                MUL: begin
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;
                end

                NORMALIZE: begin
                    // Normalize product and set exponent accordingly

                    // Check MSB 47:
                    // If 1, shift mantissa right 0 bits, exponent +1
                    // else shift mantissa left 1 bit, exponent unchanged

                    if (product[47] == 1'b1) begin
                        norm_mantissa <= product[47:24];
                        norm_exponent <= exponent_sum + 10'sd1;
                        guard_bit  <= product[23];
                        round_bit  <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        norm_mantissa <= product[46:23];
                        norm_exponent <= exponent_sum;
                        guard_bit  <= product[22];
                        round_bit  <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                ROUND: begin
                    // Round to nearest even
                    // round_increment = guard & (round | sticky | lsb)
                    if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0]))
                        rounded_mantissa <= norm_mantissa + 1;
                    else
                        rounded_mantissa <= norm_mantissa;

                    rounded_exponent <= norm_exponent;

                    // Check mantissa overflow after rounding
                    if (rounded_mantissa[23]) begin
                        rounded_mantissa <= rounded_mantissa >> 1;
                        rounded_exponent <= norm_exponent + 10'sd1;
                    end
                end

                PACK: begin
                    // Assemble final result with special case handling
                    if (is_nan) begin
                        // Quiet NaN: sign=0, exp=0xFF, mantissa MSB=1 (quiet bit), rest 0
                        z <= {1'b0, 8'hFF, 23'h400000};
                    end else if (is_inf) begin
                        // Infinity with sign
                        z <= {z_sign_reg, 8'hFF, 23'd0};
                    end else if (is_zero) begin
                        // Zero with sign
                        z <= {z_sign_reg, 31'd0};
                    end else if (rounded_exponent >= 10'sd255) begin
                        // Overflow to infinity
                        z <= {z_sign_reg, 8'hFF, 23'd0};
                    end else if (rounded_exponent <= 10'sd0) begin
                        // Underflow to zero (no denormals implemented)
                        z <= {z_sign_reg, 31'd0};
                    end else begin
                        // Normalized result
                        z <= {z_sign_reg, rounded_exponent[7:0], rounded_mantissa[22:0]};
                    end
                end

                default: begin
                    // Default state to avoid latches
                    z <= 32'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE:      next_state = DECODE;
            DECODE:    next_state = MUL;
            MUL:       next_state = NORMALIZE;
            NORMALIZE: next_state = ROUND;
            ROUND:     next_state = PACK;
            PACK:      next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

endmodule