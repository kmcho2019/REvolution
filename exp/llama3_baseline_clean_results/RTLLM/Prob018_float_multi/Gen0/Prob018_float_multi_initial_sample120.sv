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

// Initialize counter on reset
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

// Input processing
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Extract mantissas, exponents, and sign bits
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end
end

// Special cases handling
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Check for NaN and infinity
        if ((a_exponent == 9'b11111111) && (a_mantissa!= 24'b0)) begin
            // NaN
            z <= 32'b1;
        end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 24'b0)) begin
            // NaN
            z <= 32'b1;
        end else if ((a_exponent == 9'b11111111) && (a_mantissa == 24'b0)) begin
            // Infinity
            z_sign <= a_sign;
            z_exponent <= 9'b11111111;
            z_mantissa <= 24'b0;
            z <= {z_sign, z_exponent, z_mantissa};
        end else if ((b_exponent == 9'b11111111) && (b_mantissa == 24'b0)) begin
            // Infinity
            z_sign <= b_sign;
            z_exponent <= 9'b11111111;
            z_mantissa <= 24'b0;
            z <= {z_sign, z_exponent, z_mantissa};
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            // Normalize a_mantissa
            a_mantissa <= {a_mantissa[22:0], 1'b0};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 1'b0) begin
            // Normalize b_mantissa
            b_mantissa <= {b_mantissa[22:0], 1'b0};
            b_exponent <= b_exponent - 1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Multiply mantissas
        product <= {a_mantissa, 24'b0} * {b_mantissa, 24'b0};
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 127;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Round the result
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= product[47:0]!= 50'b0;
        if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
            // Round up
            z_mantissa <= {1'b1, product[48:25]};
            z_exponent <= z_exponent + 1;
        end else begin
            // Round down
            z_mantissa <= product[48:25];
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b110) begin
        // Format the result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

// Reset the counter
always @(posedge clk) begin
    if (counter == 3'b111) begin
        counter <= 3'b000;
    end
end

endmodule