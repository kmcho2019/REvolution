module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [31:0] result;

// Internal signals
reg a_sign, b_sign;
reg [7:0] a_exponent, b_exponent;
reg [22:0] a_mantissa, b_mantissa;
reg result_sign;
reg [8:0] result_exponent;
reg [47:0] product;
reg [22:0] result_mantissa;

// Input Processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        a_exponent <= 8'b0;
        b_exponent <= 8'b0;
        a_mantissa <= 23'b0;
        b_mantissa <= 23'b0;
    end else begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Floating-point Multiplication
always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 32'b0;
    end else begin
        // Check for NaN and Infinity
        if ((a_exponent == 8'b11111111) || (b_exponent == 8'b11111111)) begin
            if ((a_exponent == 8'b11111111) && (a_mantissa != 23'b0)) begin
                result <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // NaN
            end else if ((b_exponent == 8'b11111111) && (b_mantissa != 23'b0)) begin
                result <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // NaN
            end else if (a_exponent == 8'b11111111) begin
                result <= (a_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end else begin
                result <= (b_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end
        end else begin
            // Calculate the sign of the result
            result_sign <= a_sign ^ b_sign;

            // Calculate the exponent of the result
            result_exponent <= a_exponent + b_exponent - 9'b10000000;

            // Multiply the mantissas
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};

            // Normalize and round the product
            if (product[47]) begin
                result_mantissa <= product[46:24];
                result_exponent <= result_exponent + 1'b1;
            end else begin
                result_mantissa <= product[45:23];
            end

            // Apply rounding rules
            if (product[23] || |product[22:0]) begin
                result_mantissa <= result_mantissa + 1;
                if (result_mantissa[22]) begin
                    result_mantissa <= 23'b0;
                    result_exponent <= result_exponent + 1'b1;
                end
            end

            // Construct the result
            result <= {result_sign, result_exponent[7:0], result_mantissa};
        end
    end
end

assign z = result;

endmodule