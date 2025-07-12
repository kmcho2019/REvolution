module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Define states for the state machine
    enum logic [1:0] {IDLE, CALCULATE, OUTPUT} state, next_state;

    // Internal signals
    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    reg [47:0] mantissa_product;
    reg is_nan_a, is_nan_b, is_inf_a, is_inf_b;
    reg guard_bit, round_bit, sticky;

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
            IDLE: next_state = CALCULATE;
            CALCULATE: next_state = OUTPUT;
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Calculate stage
    always @(posedge clk) begin
        if (state == CALCULATE) begin
            // Extract exponent and mantissa from inputs
            exponent_a <= a[30:23];
            exponent_b <= b[30:23];
            mantissa_a <= a[22:0];
            mantissa_b <= b[22:0];
            sign_a <= a[31];
            sign_b <= b[31];

            // Check for NaN and infinity
            is_nan_a <= (exponent_a == 9'd255);
            is_nan_b <= (exponent_b == 9'd255);
            is_inf_a <= (exponent_a == 9'd255) && (mantissa_a == 0);
            is_inf_b <= (exponent_b == 9'd255) && (mantissa_b == 0);

            // Check if either input is NaN, and set output to NaN if so
            if (is_nan_a || is_nan_b) begin
                result_sign <= 1'b1; // Default sign for NaN
                result_exponent <= 9'd255;
                result_mantissa <= 23'd0;
            end else if (is_inf_a || is_inf_b) begin
                // Handle infinity cases
                result_sign <= (is_inf_a && sign_a) || (is_inf_b && sign_b);
                result_exponent <= 9'd255;
                result_mantissa <= 23'd0;
            end else begin
                // Calculate result exponent and mantissa
                result_exponent <= exponent_a + exponent_b - 9'd127;
                mantissa_product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};

                // Calculate result sign
                result_sign <= sign_a ^ sign_b;

                // Calculate rounding control bits
                guard_bit <= mantissa_product[22];
                round_bit <= mantissa_product[21];
                sticky <= |mantissa_product[20:0];
            end
        end
    end

    // Output stage
    always @(posedge clk) begin
        if (state == OUTPUT) begin
            if (is_nan_a || is_nan_b) begin
                z <= {1'b1, 8'd255, 23'd0}; // NaN
            end else if (is_inf_a || is_inf_b) begin
                z <= {result_sign, 8'd255, 23'd0}; // Infinity
            end else if (result_exponent > 9'd254) begin
                z <= {result_sign, 8'd255, 23'd0}; // Overflow
            end else if (result_exponent < 1) begin
                z <= {result_sign, 8'd0, 23'd0}; // Underflow
            end else begin
                // Normalize result mantissa
                if (mantissa_product[47]) begin
                    result_mantissa <= mantissa_product[46:23] + (mantissa_product[22] || mantissa_product[21:0] != 0);
                    result_exponent <= result_exponent + 1;
                end else begin
                    result_mantissa <= mantissa_product[23:0];
                end

                // Round result to nearest even
                if (guard_bit && (round_bit || sticky)) begin
                    result_mantissa <= result_mantissa + 1;
                    if (result_mantissa == 24'd1_000_000) begin
                        result_mantissa <= 24'd0;
                        result_exponent <= result_exponent + 1;
                    end
                end

                z <= {result_sign, result_exponent, result_mantissa};
            end
        end
    end

endmodule