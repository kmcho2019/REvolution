module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else if (counter == 3'b100) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Extract mantissas, exponents, and sign bits
always @(posedge clk) begin
    if (counter == 3'b001) begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
    end
end

// Handle special cases (NaN, infinity)
always @(posedge clk) begin
    if (counter == 3'b010) begin
        if ((a_exponent == 9'd255) && (a_mantissa!= 23'd0)) begin
            z <= a; // NaN
        end else if ((b_exponent == 9'd255) && (b_mantissa!= 23'd0)) begin
            z <= b; // NaN
        end else if ((a_exponent == 9'd255) && (a_mantissa == 23'd0) && (b_exponent == 9'd255) && (b_mantissa == 23'd0)) begin
            z <= {a_sign, 8'd255, 23'd0}; // Infinity
        end
    end
end

// Normalize mantissas
always @(posedge clk) begin
    if (counter == 3'b011) begin
        if (a_mantissa[22] == 1'b0) begin
            a_mantissa <= a_mantissa << 1;
            a_exponent <= a_exponent - 1'b1;
        end
        if (b_mantissa[22] == 1'b0) begin
            b_mantissa <= b_mantissa << 1;
            b_exponent <= b_exponent - 1'b1;
        end
    end
end

// Multiply mantissas and combine signs
always @(posedge clk) begin
    if (counter == 3'b100) begin
        product <= {a_mantissa, 23'd0} * {b_mantissa, 23'd0};
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 9'd127;
    end
end

// Round result and adjust exponent
always @(posedge clk) begin
    if (counter == 3'b101) begin
        z_mantissa <= product[46:23];
        guard_bit <= product[22];
        round_bit <= product[21];
        sticky <= |product[20:0];
        if ((guard_bit == 1'b1) && (round_bit == 1'b1) || (sticky == 1'b1)) begin
            z_mantissa <= z_mantissa + 1'b1;
            if (z_mantissa[22] == 1'b1) begin
                z_exponent <= z_exponent + 1'b1;
                z_mantissa <= z_mantissa >> 1;
            end
        end
    end
end

// Format result in IEEE 754 standard
always @(posedge clk) begin
    if (counter == 3'b110) begin
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule