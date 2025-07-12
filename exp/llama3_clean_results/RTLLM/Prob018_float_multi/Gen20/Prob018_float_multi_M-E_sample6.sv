module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Input Stage
    reg [31:0] a_reg, b_reg;
    wire [7:0] a_exponent, b_exponent;
    wire [22:0] a_mantissa, b_mantissa;
    wire a_sign, b_sign;

    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    assign a_exponent = a_reg[30:23];
    assign b_exponent = b_reg[30:23];
    assign a_mantissa = a_reg[22:0];
    assign b_mantissa = b_reg[22:0];
    assign a_sign = a_reg[31];
    assign b_sign = b_reg[31];

    // Special Case Handling Stage
    reg special_case;
    always @(posedge clk) begin
        if (rst) begin
            special_case <= 0;
        end else begin
            if ((a_exponent == 8'd255) || (b_exponent == 8'd255)) begin
                special_case <= 1;
            end else begin
                special_case <= 0;
            end
        end
    end

    // Exponent Calculation Stage
    reg [8:0] result_exponent;
    always @(posedge clk) begin
        if (rst) begin
            result_exponent <= 0;
        end else begin
            if (special_case) begin
                result_exponent <= 9'd255;
            end else begin
                result_exponent <= a_exponent + b_exponent - 9'd127;
            end
        end
    end

    // Mantissa Multiplication Stage
    reg [46:0] product;
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
        end else begin
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        end
    end

    // Rounding and Normalization Stage
    reg [22:0] normalized_mantissa;
    reg [1:0] normalize_shift;
    always @(posedge clk) begin
        if (rst) begin
            normalized_mantissa <= 0;
            normalize_shift <= 0;
        end else begin
            if (product[46]) begin
                normalized_mantissa <= product[45:23];
                normalize_shift <= 1;
            end else begin
                normalized_mantissa <= product[44:22];
                normalize_shift <= 0;
            end
        end
    end

    // Output Formatting Stage
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (special_case) begin
                z <= {a_sign ^ b_sign, 8'd255, 23'd0};
            end else if (result_exponent + normalize_shift > 9'd254) begin
                z <= {a_sign ^ b_sign, 8'd255, 23'd0};
            end else if (result_exponent + normalize_shift < 1) begin
                z <= {a_sign ^ b_sign, 8'd0, 23'd0};
            end else begin
                z <= {a_sign ^ b_sign, result_exponent + normalize_shift, normalized_mantissa};
            end
        end
    end

endmodule