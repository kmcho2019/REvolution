module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Extract mantissas, exponents, and sign bits from inputs
always @(*) begin
    a_mantissa = a[22:0];
    b_mantissa = b[22:0];
    a_exponent = a[30:23];
    b_exponent = b[30:23];
    a_sign = a[31];
    b_sign = b[31];
end

// Handle special cases like NaN and infinity
always @(*) begin
    if ((a_exponent == 10'b1111111111) && (a_mantissa != 0)) begin
        // a is NaN
        z = a;
    end else if ((b_exponent == 10'b1111111111) && (b_mantissa != 0)) begin
        // b is NaN
        z = b;
    end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 0) && (b_exponent == 10'b1111111111) && (b_mantissa == 0)) begin
        // both a and b are infinity
        if (a_sign == b_sign) begin
            // same sign
            z = {1'b0, 8'b11111111, 23'b0};
        end else begin
            // different signs
            z = {1'b0, 8'b00000000, 23'b0};
        end
    end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 0)) begin
        // a is infinity
        z = {a_sign, 8'b11111111, 23'b0};
    end else if ((b_exponent == 10'b1111111111) && (b_mantissa == 0)) begin
        // b is infinity
        z = {b_sign, 8'b11111111, 23'b0};
    end else begin
        // normal numbers
        z = 0;
    end
end

// Normalization and multiplication
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end else if (counter == 0) begin
        // normalize mantissas
        if (a_mantissa[23] == 0) begin
            a_mantissa = {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 0) begin
            b_mantissa = {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1;
        end
        // multiply mantissas
        product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
        counter <= 1;
    end else if (counter == 1) begin
        // calculate exponent
        z_exponent <= a_exponent + b_exponent + 1;
        // calculate sign
        z_sign <= a_sign ^ b_sign;
        counter <= 2;
    end else if (counter == 2) begin
        // round and adjust
        guard_bit = product[47];
        round_bit = product[46];
        sticky = |product[45:0];
        if ((guard_bit == 1) && (round_bit == 1) && (sticky == 1)) begin
            z_mantissa = {1'b1, product[45:23]} + 1;
        end else if ((guard_bit == 1) && (round_bit == 1)) begin
            z_mantissa = {1'b1, product[45:23]} + 1;
        end else begin
            z_mantissa = {1'b1, product[45:23]};
        end
        // adjust exponent
        if (z_mantissa[23] == 1) begin
            z_exponent <= z_exponent + 1;
            z_mantissa = {1'b0, z_mantissa[22:0]};
        end
        counter <= 3;
    end else if (counter == 3) begin
        // output generation
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
        counter <= 0;
    end
end

endmodule