module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Input Decoding
wire [23:0] a_mantissa, b_mantissa; // Mantissas
wire [8:0] a_exponent, b_exponent; // Exponents
wire a_sign, b_sign; // Sign bits

assign a_mantissa = a[22:0];
assign b_mantissa = b[22:0];
assign a_exponent = a[30:23];
assign b_exponent = b[30:23];
assign a_sign = a[31];
assign b_sign = b[31];

// Special Case Handling
reg a_nan, b_nan; // NaN flags
reg a_inf, b_inf; // Infinity flags

always @(posedge clk) begin
    if (rst) begin
        a_nan <= 0;
        b_nan <= 0;
        a_inf <= 0;
        b_inf <= 0;
    end else begin
        a_nan <= (a_exponent == 9'b11111111) && (a_mantissa != 0);
        b_nan <= (b_exponent == 9'b11111111) && (b_mantissa != 0);
        a_inf <= (a_exponent == 9'b11111111) && (a_mantissa == 0);
        b_inf <= (b_exponent == 9'b11111111) && (b_mantissa == 0);
    end
end

// Exponent Adjustment
wire [8:0] z_exponent; // New exponent

assign z_exponent = a_exponent + b_exponent - 9'b10000000;

// Mantissa Multiplication
reg [49:0] product; // Product of mantissas

always @(posedge clk) begin
    if (rst) begin
        product <= 0;
    end else begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Rounding and Normalization
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

// Output Formatting
reg z_sign; // Sign of result

always @(posedge clk) begin
    if (rst) begin
        z_sign <= 0;
    end else begin
        z_sign <= a_sign ^ b_sign;
    end
end

reg [31:0] z_reg; // Final result

always @(posedge clk) begin
    if (rst) begin
        z_reg <= 0;
    end else begin
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