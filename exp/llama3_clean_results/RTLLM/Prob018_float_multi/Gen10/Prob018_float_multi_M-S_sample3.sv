module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Internal signals
    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    reg [47:0] mantissa_product;
    reg is_nan_a, is_nan_b, is_inf_a, is_inf_b;

    // Input Processing
    always @(*) begin
        exponent_a = a[30:23];
        exponent_b = b[30:23];
        mantissa_a = a[22:0];
        mantissa_b = b[22:0];
        sign_a = a[31];
        sign_b = b[31];

        is_nan_a = (exponent_a == 9'd255) && (mantissa_a != 0);
        is_nan_b = (exponent_b == 9'd255) && (mantissa_b != 0);
        is_inf_a = (exponent_a == 9'd255) && (mantissa_a == 0);
        is_inf_b = (exponent_b == 9'd255) && (mantissa_b == 0);
    end

    // Special Cases Handling
    always @(*) begin
        if (is_nan_a || is_nan_b) begin
            result_exponent = 9'd255;
            result_mantissa = 24'd0;
            result_sign = 1'b0;
        end else if (is_inf_a || is_inf_b) begin
            result_exponent = 9'd255;
            result_mantissa = 24'd0;
            result_sign = sign_a ^ sign_b;
        end else begin
            // Exponent Calculation
            result_exponent = exponent_a + exponent_b - 9'd127;

            // Mantissa Multiplication
            mantissa_product = {1'b1, mantissa_a} * {1'b1, mantissa_b};

            // Normalization and Rounding
            if (mantissa_product[47]) begin
                result_mantissa = mantissa_product[46:23] + 1;
                result_exponent = result_exponent + 1;
            end else begin
                result_mantissa = mantissa_product[23:0];
            end

            // Sign calculation
            result_sign = sign_a ^ sign_b;
        end
    end

    // Output Formatting
    always @(*) begin
        z = {result_sign, result_exponent, result_mantissa};
    end

    // Reset
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end
    end

endmodule