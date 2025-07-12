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

    // Input Decode (ID) stage
    always @(*) begin
        exponent_a = a[30:23];
        exponent_b = b[30:23];
        mantissa_a = a[22:0];
        mantissa_b = b[22:0];
        sign_a = a[31];
        sign_b = b[31];

        is_nan_a = (exponent_a == 9'd255) && (mantissa_a!= 0);
        is_nan_b = (exponent_b == 9'd255) && (mantissa_b!= 0);
        is_inf_a = (exponent_a == 9'd255) && (mantissa_a == 0);
        is_inf_b = (exponent_b == 9'd255) && (mantissa_b == 0);
    end

    // Exponent Calculation (EC) stage
    always @(*) begin
        if (is_nan_a || is_nan_b) begin
            result_exponent = 9'd255;
        end else if (is_inf_a || is_inf_b) begin
            result_exponent = 9'd255;
        end else begin
            result_exponent = exponent_a + exponent_b - 9'd127;
        end
    end

    // Mantissa Multiplication (MM) stage
    always @(*) begin
        mantissa_product = {1'b1, mantissa_a} * {1'b1, mantissa_b};
    end

    // Normalization and Rounding (NR) stage
    always @(*) begin
        if (mantissa_product[47]) begin
            result_mantissa = mantissa_product[46:23] + 1;
            result_exponent = result_exponent + 1;
        end else begin
            result_mantissa = mantissa_product[23:0];
        end
    end

    // Output Formatting (OF) stage
    always @(*) begin
        if (is_nan_a || is_nan_b) begin
            z = {1'b0, 9'd255, 24'd0};
        end else if (is_inf_a || is_inf_b) begin
            z = {sign_a ^ sign_b, 9'd255, 24'd0};
        end else begin
            z = {sign_a ^ sign_b, result_exponent, result_mantissa};
        end
    end

    // Pipeline registers
    reg [31:0] stage1_out, stage2_out, stage3_out, stage4_out;

    always @(posedge clk) begin
        if (rst) begin
            stage1_out <= 0;
            stage2_out <= 0;
            stage3_out <= 0;
            stage4_out <= 0;
        end else begin
            stage1_out <= {sign_a, exponent_a, mantissa_a};
            stage2_out <= {sign_b, exponent_b, mantissa_b};
            stage3_out <= {result_exponent, result_mantissa};
            stage4_out <= z;
        end
    end

endmodule