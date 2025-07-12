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
    reg is_nan, is_inf;

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
            is_nan <= (exponent_a == 9'd255) || (exponent_b == 9'd255);
            is_inf <= ((exponent_a == 9'd255) && (mantissa_a == 0)) || ((exponent_b == 9'd255) && (mantissa_b == 0));

            // Calculate result exponent and mantissa
            result_exponent <= exponent_a + exponent_b - 9'd127;
            mantissa_product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};

            // Calculate result sign
            result_sign <= sign_a ^ sign_b;
        end
    end

    // Output stage
    always @(posedge clk) begin
        if (state == OUTPUT) begin
            // Check for overflow and underflow
            if (result_exponent > 9'd254) begin
                z <= {1'b0, 8'd255, 23'd0}; // Infinity
            end else if (result_exponent < 1) begin
                z <= {result_sign, 8'd0, 23'd0}; // Zero
            end else if (is_nan) begin
                z <= {1'b1, 8'd255, 23'd0}; // NaN
            end else if (is_inf) begin
                z <= {result_sign, 8'd255, 23'd0}; // Infinity
            end else begin
                // Normalize result mantissa
                if (mantissa_product[47]) begin
                    result_mantissa <= mantissa_product[46:23] + (mantissa_product[22] || mantissa_product[21:0]!= 0);
                    result_exponent <= result_exponent + 1;
                end else begin
                    result_mantissa <= mantissa_product[23:0];
                end
                z <= {result_sign, result_exponent, result_mantissa};
            end
        end
    end

endmodule