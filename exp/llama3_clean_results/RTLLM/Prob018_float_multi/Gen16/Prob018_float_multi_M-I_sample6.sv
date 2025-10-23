module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] a_sign, a_exponent, a_mantissa; // Extracted components of a
reg [31:0] b_sign, b_exponent, b_mantissa; // Extracted components of b
reg [49:0] product; // Product of mantissas with sufficient width
reg [7:0] z_exponent; // Exponent of result
reg [22:0] z_mantissa; // Mantissa of result
reg z_sign; // Sign of result
reg guard_bit, round_bit, sticky; // Rounding control bits
reg a_is_nan, b_is_nan, a_is_inf, b_is_inf; // Flags for NaN and infinity

// Stage 1: Floating-Point Format Extraction
always @(posedge clk) begin
    if (rst) begin
        a_sign <= 0; a_exponent <= 0; a_mantissa <= 0;
        b_sign <= 0; b_exponent <= 0; b_mantissa <= 0;
        a_is_nan <= 0; b_is_nan <= 0; a_is_inf <= 0; b_is_inf <= 0;
    end else begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]}; // Implicit 1 for mantissa
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]}; // Implicit 1 for mantissa
        // Check for NaN and infinity
        a_is_nan <= (a_exponent == 8'd255) && (a_mantissa != 0);
        b_is_nan <= (b_exponent == 8'd255) && (b_mantissa != 0);
        a_is_inf <= (a_exponent == 8'd255) && (a_mantissa == 0);
        b_is_inf <= (b_exponent == 8'd255) && (b_mantissa == 0);
    end
end

// Stage 2: Mantissa Multiplication using DSP Block
always @(posedge clk) begin
    if (rst) begin
        product <= 0;
    end else if (a_is_nan || b_is_nan) begin
        // Result is NaN if either operand is NaN
        product <= {50{1'b1}};
    end else if (a_is_inf && b_is_inf) begin
        // Result is infinity if both operands are infinity
        product <= {50{1'b1}};
    end else begin
        product <= a_mantissa * b_mantissa;
    end
end

// Stage 3: Exponent Calculation
always @(posedge clk) begin
    if (rst) begin
        z_exponent <= 0;
    end else if (a_is_nan || b_is_nan) begin
        // Exponent is all ones for NaN result
        z_exponent <= 8'd255;
    end else if (a_is_inf || b_is_inf) begin
        // Exponent is all ones for infinity result
        z_exponent <= 8'd255;
    end else begin
        z_exponent <= a_exponent + b_exponent - 8'd127; // Bias adjustment
    end
end

// Stage 4: Rounding and Normalization
always @(posedge clk) begin
    if (rst) begin
        z_mantissa <= 0;
        guard_bit <= 0; round_bit <= 0; sticky <= 0;
    end else if (a_is_nan || b_is_nan) begin
        // Mantissa is all ones for NaN result
        z_mantissa <= 23'd0;
    end else if (a_is_inf || b_is_inf) begin
        // Mantissa is zero for infinity result
        z_mantissa <= 23'd0;
    end else begin
        guard_bit <= product[23];
        round_bit <= product[22];
        sticky <= |product[21:0];
        if (round_bit && (guard_bit || sticky)) begin
            z_mantissa <= product[47:24] + 1;
        end else begin
            z_mantissa <= product[47:24];
        end
    end
end

// Stage 5: Result Formatting
always @(posedge clk) begin
    if (rst) begin
        z_sign <= 0; z <= 0;
    end else if (a_is_nan || b_is_nan) begin
        // Sign is zero for NaN result
        z_sign <= 0;
        z <= {32{1'b1}};
    end else if (a_is_inf || b_is_inf) begin
        // Sign is determined by operands for infinity result
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, 8'd255, 23'd0};
    end else begin
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule