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
    reg [2:0] pipeline_stage;

    // Pre-processing stage
    always @(posedge clk) begin
        if (rst) begin
            pipeline_stage <= 0;
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
        end else if (pipeline_stage == 0) begin
            pipeline_stage <= 1;
        end else if (pipeline_stage == 1) begin
            // Exponent calculation stage
            result_exponent <= exponent_a + exponent_b - 9'd127;
            pipeline_stage <= 2;
        end else if (pipeline_stage == 2) begin
            // Mantissa multiplication stage
            mantissa_product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};
            pipeline_stage <= 3;
        end else if (pipeline_stage == 3) begin
            // Normalization and rounding stage
            if (mantissa_product[47]) begin
                result_mantissa <= mantissa_product[46:23] + 1;
                result_exponent <= result_exponent + 1;
            end else begin
                result_mantissa <= mantissa_product[23:0];
            end
            pipeline_stage <= 4;
        end else if (pipeline_stage == 4) begin
            // Post-processing stage
            result_sign <= sign_a ^ sign_b;
            z <= {result_sign, result_exponent, result_mantissa};
            pipeline_stage <= 0;
        end
    end

    // Special cases handling
    always @(*) begin
        if (is_nan_a || is_nan_b) begin
            z = 32'd0;
        end else if (is_inf_a || is_inf_b) begin
            z = {1'b0, 8'd255, 23'd0};
        end
    end

endmodule