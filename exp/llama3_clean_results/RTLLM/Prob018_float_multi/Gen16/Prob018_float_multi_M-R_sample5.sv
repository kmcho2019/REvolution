module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    reg [1:0] state, next_state;
    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    reg [47:0] mantissa_product;
    reg is_nan, is_inf;
    reg guard_bit, round_bit, sticky;

    // State machine
    always @(posedge clk) begin
        if (rst) begin
            state <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b00;
            default: next_state = 2'b00;
        endcase
    end

    // Input extraction
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = a[22:0];
    assign mantissa_b = b[22:0];
    assign sign_a = a[31];
    assign sign_b = b[31];

    // Special cases handling
    assign is_nan = (exponent_a == 9'd255) || (exponent_b == 9'd255);
    assign is_inf = ((exponent_a == 9'd255) && (mantissa_a == 0)) || ((exponent_b == 9'd255) && (mantissa_b == 0));

    // Calculate stage
    always @(posedge clk) begin
        if (state == 2'b01) begin
            result_exponent <= exponent_a + exponent_b - 9'd127;
            mantissa_product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};
            result_sign <= sign_a ^ sign_b;
            guard_bit <= mantissa_product[22];
            round_bit <= mantissa_product[21];
            sticky <= |mantissa_product[20:0];
        end
    end

    // Output stage
    always @(posedge clk) begin
        if (state == 2'b10) begin
            if (result_exponent > 9'd254) begin
                z <= {result_sign, 8'd255, 23'd0}; // Infinity
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