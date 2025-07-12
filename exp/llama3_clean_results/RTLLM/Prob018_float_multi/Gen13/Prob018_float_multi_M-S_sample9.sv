module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    reg [23:0] mantissa_a, mantissa_b, result_mantissa;
    reg [7:0] exponent_a, exponent_b, result_exponent;
    reg sign_a, sign_b, result_sign;
    reg [47:0] product;
    reg is_nan_a, is_nan_b, is_inf_a, is_inf_b;

    // Input processing
    assign mantissa_a = a[22:0];
    assign exponent_a = a[30:23];
    assign sign_a = a[31];
    assign mantissa_b = b[22:0];
    assign exponent_b = b[30:23];
    assign sign_b = b[31];

    // Special case handling
    assign is_nan_a = (exponent_a == 8'd255) && (mantissa_a!= 0);
    assign is_nan_b = (exponent_b == 8'd255) && (mantissa_b!= 0);
    assign is_inf_a = (exponent_a == 8'd255) && (mantissa_a == 0);
    assign is_inf_b = (exponent_b == 8'd255) && (mantissa_b == 0);

    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Handle special cases
            if (is_nan_a || is_nan_b) begin
                z <= 32'd0; // Or propagate NaN
            end else if (is_inf_a || is_inf_b) begin
                z <= {1'b0, 8'd255, 23'd0}; // Handle infinity
            end else begin
                // Perform multiplication
                product <= {1'b1, mantissa_a} * {1'b1, mantissa_b};
                
                // Normalize and calculate exponent
                if (product[47]) begin
                    result_mantissa <= product[46:23];
                    result_exponent <= exponent_a + exponent_b - 8'd127 + 1;
                end else begin
                    result_mantissa <= product[23:0];
                    result_exponent <= exponent_a + exponent_b - 8'd127;
                end
                
                // Round
                if (product[22] || product[21:0]!= 0) begin
                    result_mantissa <= result_mantissa + 1;
                    if (result_mantissa[23]) begin
                        result_mantissa <= 0;
                        result_exponent <= result_exponent + 1;
                    end
                end
                
                // Handle overflow and underflow
                if (result_exponent > 8'd254) begin
                    z <= {1'b0, 8'd255, 23'd0}; // Overflow
                end else if (result_exponent < 1) begin
                    z <= {1'b0, 1, 23'd0}; // Underflow
                end else begin
                    result_sign <= sign_a ^ sign_b;
                    z <= {result_sign, result_exponent, result_mantissa};
                end
            end
        end
    end

endmodule