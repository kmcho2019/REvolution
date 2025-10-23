module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Input Processing Unit (IPU)
    wire [8:0] exponent_a, exponent_b;
    wire [23:0] mantissa_a, mantissa_b;
    wire sign_a, sign_b;
    wire is_nan, is_inf;

    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = a[22:0];
    assign mantissa_b = b[22:0];
    assign sign_a = a[31];
    assign sign_b = b[31];

    assign is_nan = (exponent_a == 9'd255) || (exponent_b == 9'd255);
    assign is_inf = ((exponent_a == 9'd255) && (mantissa_a == 0)) || ((exponent_b == 9'd255) && (mantissa_b == 0));

    // Mantissa Multiplier (MM)
    wire [47:0] product;
    reg [47:0] product_reg;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 0;
        end else begin
            product_reg <= {1'b1, mantissa_a} * {1'b1, mantissa_b};
        end
    end

    assign product = product_reg;

    // Exponent Calculator (EC)
    wire [9:0] result_exponent;
    assign result_exponent = exponent_a + exponent_b - 10'd127;

    // Rounding and Normalization Unit (RNU)
    wire [23:0] normalized_mantissa;
    wire [2:0] normalize_shift;
    reg [23:0] normalized_mantissa_reg;
    reg [2:0] normalize_shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            normalized_mantissa_reg <= 0;
            normalize_shift_reg <= 0;
        end else begin
            normalized_mantissa_reg <= product[46:23] + (product[22] || product[21:0]!= 0);
            normalize_shift_reg <= product[47] ? 1'b1 : 1'b0;
        end
    end

    assign normalized_mantissa = normalized_mantissa_reg;
    assign normalize_shift = normalize_shift_reg;

    // Output Formatting Unit (OFU)
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (is_nan) begin
                z <= {1'b1, 8'd255, 23'd0}; // NaN
            end else if (is_inf) begin
                z <= {sign_a ^ sign_b, 8'd255, 23'd0}; // Infinity
            end else if (result_exponent > 9'd254) begin
                z <= {sign_a ^ sign_b, 8'd255, 23'd0}; // Overflow
            end else if (result_exponent < 1) begin
                z <= {sign_a ^ sign_b, 8'd0, 23'd0}; // Underflow
            end else begin
                z <= {sign_a ^ sign_b, result_exponent + normalize_shift, normalized_mantissa};
            end
        end
    end

endmodule