module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [2:0] stage; // Stage counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Input Processing Stage
always @(posedge clk) begin
    if (rst) begin
        stage <= 3'b000;
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else if (stage == 3'b000) begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        stage <= stage + 1;
    end
end

// Exponent Calculation Stage
always @(posedge clk) begin
    if (stage == 3'b001) begin
        z_exponent <= a_exponent + b_exponent - 9'b10000000;
        if (z_exponent > 9'b11111110) begin
            z_exponent <= 9'b11111111; // Overflow
        end else if (z_exponent < 9'b1) begin
            z_exponent <= 9'b0; // Underflow
        end
        stage <= stage + 1;
    end
end

// Mantissa Multiplication Stage
always @(posedge clk) begin
    if (stage == 3'b010) begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        stage <= stage + 1;
    end
end

// Rounding/Normalization Stage
always @(posedge clk) begin
    if (stage == 3'b011) begin
        guard_bit <= product[24];
        round_bit <= product[23];
        sticky <= |product[22:0];
        if (guard_bit || round_bit || sticky) begin
            z_mantissa <= product[48:25] + 1;
        end else begin
            z_mantissa <= product[48:25];
        end
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent, z_mantissa};
        stage <= 3'b000; // Reset stage counter
    end
end

endmodule