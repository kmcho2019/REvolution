module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Define states for the state machine
    enum logic [2:0] {IDLE, PRE_PROCESS, EXP_CALC, MANT_MULT, ROUND_ADJUST, POST_PROCESS} state, next_state;

    // Internal signals
    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    reg [47:0] mantissa_product;
    reg is_nan_a, is_nan_b, is_inf_a, is_inf_b;
    reg guard_bit, round_bit, sticky;
    reg underflow, overflow;

    // State machine
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = PRE_PROCESS;
            PRE_PROCESS: next_state = EXP_CALC;
            EXP_CALC: next_state = MANT_MULT;
            MANT_MULT: next_state = ROUND_ADJUST;
            ROUND_ADJUST: next_state = POST_PROCESS;
            POST_PROCESS: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Pre-processing stage
    always @(posedge clk) begin
        if (state == PRE_PROCESS) begin
            exponent_a <= a[30:23];
            exponent_b <= b[30:23];
            mantissa_a <= a[22:0];
            mantissa_b <= b[22:0];
            sign_a <= a[31];
            sign_b <= b[31];
            is_nan_a <= (exponent_a == 9'd255) && (mantissa_a!= 0);
            is_nan_b <= (exponent_b == 9'd255) && (mantissa_b!= 0);
            is_inf_a <= (exponent_a == 9'd255) && (mantissa_a == 0);
            is_inf_b <= (exponent_b == 9'd255) && (mantissa_b == 0);
        end
    end

    // Exponent calculation stage
    always @(posedge clk) begin
        if (state == EXP_CALC) begin
            result_exponent <= exponent_a + exponent_b - 9'd127;
        end
    end

    // Mantissa multiplication stage
    always @(posedge clk) begin
        if (state == MANT_MULT) begin
            mantissa_product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};
        end
    end

    // Normalization and rounding stage
    always @(posedge clk) begin
        if (state == ROUND_ADJUST) begin
            if (mantissa_product[47]) begin
                result_mantissa <= mantissa_product[46:23] + (mantissa_product[22] || mantissa_product[21:0]!= 0);
                result_exponent <= result_exponent + 1;
            end else begin
                result_mantissa <= mantissa_product[23:0];
            end
            // Rounding
            guard_bit <= mantissa_product[22];
            round_bit <= mantissa_product[21];
            sticky <= |mantissa_product[20:0];
        end
    end

    // Post-processing stage
    always @(posedge clk) begin
        if (state == POST_PROCESS) begin
            result_sign <= sign_a ^ sign_b;
            // Check for underflow and overflow
            if (result_exponent < 1) begin
                underflow <= 1;
                result_exponent <= 1;
            end else if (result_exponent > 254) begin
                overflow <= 1;
                result_exponent <= 255;
                result_mantissa <= 0;
            end else begin
                underflow <= 0;
                overflow <= 0;
            end
            // Handle NaN and infinity
            if (is_nan_a || is_nan_b) begin
                z <= 32'd0; // Or propagate NaN
            end else if (is_inf_a || is_inf_b) begin
                z <= {1'b0, 8'd255, 23'd0}; // Handle infinity
            end else begin
                z <= {result_sign, result_exponent, result_mantissa};
            end
        end
    end

endmodule