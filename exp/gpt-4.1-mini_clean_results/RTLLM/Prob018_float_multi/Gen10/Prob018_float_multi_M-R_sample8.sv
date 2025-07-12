module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE  = 2'd0,
        MUL   = 2'd1,
        ROUND = 2'd2
    } state_t;

    state_t state, next_state;

    // IEEE 754 parameters
    localparam EXP_BIAS = 8'd127;
    localparam EXP_MAX = 8'hFF;
    localparam EXP_MIN = 8'd0;

    // Extract fields from inputs (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases (combinational)
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == EXP_MAX) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == EXP_MAX) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == EXP_MAX) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == EXP_MAX) && (b_frac != 23'd0);

    // Internal pipeline registers for inputs and intermediate data
    reg sign_r;
    reg [9:0] exponent_r;      // 10-bit for exponent addition and adjustments
    reg [23:0] mantissa_a_r;
    reg [23:0] mantissa_b_r;

    // Product of mantissas
    reg [47:0] product_r;

    // Normalized mantissa and exponent after shift
    reg [47:0] normalized_product_r;
    reg [9:0] exponent_norm_r;

    // Rounding bits
    reg guard_bit_r;
    reg round_bit_r;
    reg sticky_bit_r;

    // Mantissa after rounding (24 bits including hidden bit)
    reg [23:0] mantissa_rounded_r;

    // Flags for special cases latched
    reg a_is_nan_r, b_is_nan_r;
    reg a_is_inf_r, b_is_inf_r;
    reg a_is_zero_r, b_is_zero_r;

    // FSM sequential logic: state transition and registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear pipeline regs
            sign_r <= 1'b0;
            exponent_r <= 10'd0;
            mantissa_a_r <= 24'd0;
            mantissa_b_r <= 24'd0;
            product_r <= 48'd0;
            normalized_product_r <= 48'd0;
            exponent_norm_r <= 10'd0;
            guard_bit_r <= 1'b0;
            round_bit_r <= 1'b0;
            sticky_bit_r <= 1'b0;
            mantissa_rounded_r <= 24'd0;

            a_is_nan_r <= 1'b0;
            b_is_nan_r <= 1'b0;
            a_is_inf_r <= 1'b0;
            b_is_inf_r <= 1'b0;
            a_is_zero_r <= 1'b0;
            b_is_zero_r <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Latch inputs and special flags
                    sign_r <= a_sign ^ b_sign;

                    // Prepare mantissas with hidden bit
                    mantissa_a_r <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    mantissa_b_r <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Exponent add and bias subtraction
                    exponent_r <= a_exp + b_exp - EXP_BIAS;

                    // Latch special flags
                    a_is_nan_r <= a_is_nan;
                    b_is_nan_r <= b_is_nan;
                    a_is_inf_r <= a_is_inf;
                    b_is_inf_r <= b_is_inf;
                    a_is_zero_r <= a_is_zero;
                    b_is_zero_r <= b_is_zero;
                end

                MUL: begin
                    // Multiply mantissas (24x24 => 48 bits)
                    product_r <= mantissa_a_r * mantissa_b_r;

                    // Normalization:
                    // If MSB product_r[47] is 1, shift right by 1 and increase exponent
                    if (product_r[47] == 1'b1) begin
                        normalized_product_r <= product_r >> 1;
                        exponent_norm_r <= exponent_r + 10'd1;
                    end else begin
                        normalized_product_r <= product_r;
                        exponent_norm_r <= exponent_r;
                    end

                    // Extract rounding bits from normalized_product_r
                    // guard = bit 23
                    // round = bit 22
                    // sticky = OR bits 21:0
                    guard_bit_r <= normalized_product_r[23];
                    round_bit_r <= normalized_product_r[22];
                    sticky_bit_r <= |normalized_product_r[21:0];

                    // Extract 24-bit mantissa (bits 46:23)
                    mantissa_rounded_r <= normalized_product_r[46:23];
                end

                ROUND: begin
                    // Rounding to nearest even
                    // Round if guard bit is set and (round or sticky or LSB mantissa is 1)
                    if (guard_bit_r && (round_bit_r || sticky_bit_r || mantissa_rounded_r[0])) begin
                        {exponent_norm_r, mantissa_rounded_r} <= {exponent_norm_r, mantissa_rounded_r} + 25'd1;
                        // Handle mantissa overflow (bit 24)
                        if (mantissa_rounded_r[24]) begin
                            // Shift mantissa right by 1, increment exponent
                            mantissa_rounded_r <= mantissa_rounded_r[24:1];
                            exponent_norm_r <= exponent_norm_r + 10'd1;
                        end
                    end

                    // Handle special cases and produce output
                    if (a_is_nan_r || b_is_nan_r) begin
                        // Output quiet NaN (sign 0, exp=FF, mantissa with MSB=1)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf_r && b_is_zero_r) || (b_is_inf_r && a_is_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf_r || b_is_inf_r) begin
                        // Result is infinity
                        z <= {sign_r, 8'hFF, 23'd0};
                    end else if (a_is_zero_r || b_is_zero_r) begin
                        // Result is zero
                        z <= {sign_r, 31'd0};
                    end else begin
                        // Normal number, handle overflow/underflow
                        if (exponent_norm_r >= EXP_MAX) begin
                            // Overflow -> infinity
                            z <= {sign_r, 8'hFF, 23'd0};
                        end else if (exponent_norm_r <= 0) begin
                            // Underflow -> zero (no subnormal handling for simplicity)
                            z <= {sign_r, 31'd0};
                        end else begin
                            // Assemble IEEE754 result (excluding leading one)
                            z <= {sign_r, exponent_norm_r[7:0], mantissa_rounded_r[22:0]};
                        end
                    end
                end

            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = MUL;
            MUL:   next_state = ROUND;
            ROUND: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule