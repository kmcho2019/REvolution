module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Internal signals
    reg [8:0] exponent_a, exponent_b;
    reg [23:0] mantissa_a, mantissa_b;
    reg sign_a, sign_b;
    reg [8:0] result_exponent;
    reg [23:0] result_mantissa;
    reg [47:0] mantissa_product;

    // Input Processing
    always @(*) begin
        exponent_a = a[30:23];
        exponent_b = b[30:23];
        mantissa_a = a[22:0];
        mantissa_b = b[22:0];
        sign_a = a[31];
        sign_b = b[31];
    end

    // Exponent Calculation
    always @(*) begin
        result_exponent = exponent_a + exponent_b - 9'd127;
    end

    // Mantissa Multiplication
    always @(*) begin
        mantissa_product = {1'b1, mantissa_a} * {1'b1, mantissa_b};
    end

    // Normalization and Rounding
    always @(*) begin
        if (mantissa_product[47]) begin
            result_mantissa = mantissa_product[46:23] + 1;
            result_exponent = result_exponent + 1;
        end else begin
            result_mantissa = mantissa_product[23:0];
        end
    end

    // Output Formatting
    always @(*) begin
        z = {sign_a ^ sign_b, result_exponent, result_mantissa};
    end

    // Reset
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end
    end

endmodule