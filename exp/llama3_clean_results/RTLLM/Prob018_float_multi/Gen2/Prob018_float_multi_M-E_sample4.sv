module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Stage 1: Input Stage
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 24'b0;
        a_exponent <= 9'b0;
        a_sign <= 1'b0;
        b_mantissa <= 24'b0;
        b_exponent <= 9'b0;
        b_sign <= 1'b0;
    end else begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
    end
end

// Stage 2: Special Cases Handling Stage
reg special_case;
always @(posedge clk) begin
    if (rst) begin
        special_case <= 1'b0;
    end else begin
        if ((a_exponent == 9'b11111111) && (a_mantissa != 24'b0)) begin
            // NaN
            special_case <= 1'b1;
        end else if ((b_exponent == 9'b11111111) && (b_mantissa != 24'b0)) begin
            // NaN
            special_case <= 1'b1;
        end else if ((a_exponent == 9'b11111111) && (a_mantissa == 24'b0)) begin
            // Infinity
            special_case <= 1'b1;
        end else if ((b_exponent == 9'b11111111) && (b_mantissa == 24'b0)) begin
            // Infinity
            special_case <= 1'b1;
        end else begin
            special_case <= 1'b0;
        end
    end
end

// Stage 3: Exponent Adjustment Stage
always @(posedge clk) begin
    if (rst) begin
        z_exponent <= 9'b0;
    end else if (!special_case) begin
        z_exponent <= a_exponent + b_exponent - 9'b10000000;
    end
end

// Stage 4: Mantissa Multiplication Stage
always @(posedge clk) begin
    if (rst) begin
        product <= 50'b0;
    end else if (!special_case) begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Stage 5: Rounding Stage
always @(posedge clk) begin
    if (rst) begin
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else if (!special_case) begin
        guard_bit <= product[24];
        round_bit <= product[23];
        sticky <= |product[22:0];
    end
end

// Stage 6: Normalization and Output Stage
always @(posedge clk) begin
    if (rst) begin
        z <= 32'b0;
    end else begin
        if (special_case) begin
            // Handle special cases
            if (a_sign ^ b_sign) begin
                // Negative result
                z <= 32'b1000_0000_0000_0000_0000_0000_0000_0000;
            end else begin
                // Positive result
                z <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
            end
        end else begin
            // Normal result
            z_sign <= a_sign ^ b_sign;
            z_mantissa <= product[48:25];
            if (guard_bit || round_bit || sticky) begin
                // Rounding (simplified, rounding up)
                z_mantissa <= z_mantissa + 1;
            end
            z <= {z_sign, z_exponent, z_mantissa};
        end
    end
end

endmodule