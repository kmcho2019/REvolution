module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] a_sign, a_exponent, a_mantissa; // Extracted components of a
reg [31:0] b_sign, b_exponent, b_mantissa; // Extracted components of b
reg [49:0] product; // Product of mantissas
reg [7:0] z_exponent; // Exponent of result
reg [22:0] z_mantissa; // Mantissa of result
reg z_sign; // Sign of result

// Stage 1: Floating-Point Format Extraction
always @(posedge clk) begin
    if (rst) begin
        a_sign <= 0; a_exponent <= 0; a_mantissa <= 0;
        b_sign <= 0; b_exponent <= 0; b_mantissa <= 0;
    end else begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]}; // Implicit 1 for mantissa
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]}; // Implicit 1 for mantissa
    end
end

// Stage 2: Mantissa Multiplication
always @(posedge clk) begin
    if (rst) begin
        product <= 0;
    end else begin
        product <= a_mantissa * b_mantissa;
    end
end

// Stage 3: Exponent Calculation
always @(posedge clk) begin
    if (rst) begin
        z_exponent <= 0;
    end else begin
        z_exponent <= a_exponent + b_exponent - 8'd127; // Bias adjustment
    end
end

// Stage 4: Rounding and Normalization
always @(posedge clk) begin
    if (rst) begin
        z_mantissa <= 0;
    end else begin
        if (product[47]) begin // MSB of product
            z_mantissa <= product[47:25]; // Normalize
            z_exponent <= z_exponent + 1;
        end else begin
            z_mantissa <= product[46:24]; // No normalization
        end
    end
end

// Stage 5: Result Formatting
always @(posedge clk) begin
    if (rst) begin
        z_sign <= 0; z <= 0;
    end else begin
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule