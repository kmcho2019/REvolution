module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    reg [8:0] exponent_a, exponent_b, result_exponent;
    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg sign_a, sign_b, result_sign;
    reg [47:0] product;
    reg is_nan, is_inf;

    // Extract exponent, mantissa, and sign from inputs
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = a[22:0];
    assign mantissa_b = b[22:0];
    assign sign_a = a[31];
    assign sign_b = b[31];

    // Check for NaN and infinity
    assign is_nan = (exponent_a == 9'd255) || (exponent_b == 9'd255);
    assign is_inf = ((exponent_a == 9'd255) && (mantissa_a == 0)) || ((exponent_b == 9'd255) && (mantissa_b == 0));

    // Calculate result exponent and mantissa
    always @(posedge clk) begin
        if (rst) begin
            result_exponent <= 0;
            result_mantissa <= 0;
            result_sign <= 0;
            product <= 0;
        end else begin
            // Calculate result exponent
            result_exponent <= exponent_a + exponent_b - 9'd127;

            // Calculate result sign
            result_sign <= sign_a ^ sign_b;

            // Calculate product of mantissas
            product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};

            // Normalize result mantissa
            if (product[47]) begin
                result_mantissa <= product[46:23] + (product[22] || product[21:0]!= 0);
                result_exponent <= result_exponent + 1;
            end else begin
                result_mantissa <= product[23:0];
            end
        end
    end

    // Generate final output
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
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
                z <= {result_sign, result_exponent, result_mantissa};
            end
        end
    end

endmodule