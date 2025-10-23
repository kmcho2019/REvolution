module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Stage 1: Input Processing
reg [23:0] a_mantissa, b_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent; // Exponents
reg a_sign, b_sign; // Sign bits
reg a_nan, b_nan; // NaN flags
reg a_inf, b_inf; // Infinity flags

always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        a_nan <= 0;
        b_nan <= 0;
        a_inf <= 0;
        b_inf <= 0;
    end else begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        a_nan <= (a_exponent == 9'b11111111) && (a_mantissa != 0);
        b_nan <= (b_exponent == 9'b11111111) && (b_mantissa != 0);
        a_inf <= (a_exponent == 9'b11111111) && (a_mantissa == 0);
        b_inf <= (b_exponent == 9'b11111111) && (b_mantissa == 0);
    end
end

// Stage 2: Exponent Processing
reg [8:0] z_exponent; // New exponent
reg overflow; // Overflow flag

always @(posedge clk) begin
    if (rst) begin
        z_exponent <= 0;
        overflow <= 0;
    end else begin
        z_exponent <= a_exponent + b_exponent - 9'b10000000;
        overflow <= (z_exponent > 9'b11111110);
    end
end

// Stage 3: Mantissa Multiplication
reg [49:0] product; // Product of mantissas

always @(posedge clk) begin
    if (rst) begin
        product <= 0;
    end else begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Stage 4: Rounding and Normalization
reg [23:0] z_mantissa; // New mantissa
reg round_bit, guard_bit, sticky; // Rounding bits

always @(posedge clk) begin
    if (rst) begin
        z_mantissa <= 0;
        round_bit <= 0;
        guard_bit <= 0;
        sticky <= 0;
    end else begin
        round_bit <= product[23];
        guard_bit <= product[24];
        sticky <= |product[22:0];
        if (guard_bit || round_bit || sticky) begin
            z_mantissa <= product[48:25] + 1;
        end else begin
            z_mantissa <= product[48:25];
        end
    end
end

// Stage 5: Output Formatting
reg z_sign; // Sign of result
reg [31:0] z_reg; // Final result

always @(posedge clk) begin
    if (rst) begin
        z_sign <= 0;
        z_reg <= 0;
    end else begin
        z_sign <= a_sign ^ b_sign;
        if (a_nan || b_nan) begin
            // NaN handling
            z_reg <= 32'b1;
        end else if (a_inf || b_inf) begin
            // Infinity handling
            if (a_sign ^ b_sign) begin
                z_reg <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // Negative Infinity
            end else begin
                z_reg <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Positive Infinity
            end
        end else begin
            // Normal result
            z_reg <= {z_sign, z_exponent, z_mantissa};
        end
    end
end

assign z = z_reg;

endmodule