module float_multi(
    input clk,    // Clock signal
    input rst,    // Reset signal (active high)
    input [31:0] a,  // First operand in IEEE 754 format
    input [31:0] b,  // Second operand in IEEE 754 format
    output reg [31:0] z  // Result of the multiplication in IEEE 754 format
);

// Internal signals
reg [2:0] counter;  // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa;  // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent;  // Exponents of input and output numbers
reg a_sign, b_sign, z_sign;  // Sign bits for inputs and output
reg [49:0] product;  // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky;  // Rounding control bits

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Input processing and extraction
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

// Special cases handling (NaN, infinity)
always @(posedge clk) begin
    if (counter == 3'b010) begin
        if ((a_exponent == 9'b11111111) && (a_mantissa != 0)) begin  // a is NaN
            z <= a;
        end else if ((b_exponent == 9'b11111111) && (b_mantissa != 0)) begin  // b is NaN
            z <= b;
        end else if ((a_exponent == 9'b11111111) && (a_mantissa == 0) && (b_exponent == 9'b11111111) && (b_mantissa == 0)) begin  // both a and b are infinity
            z <= (a_sign == b_sign) ? 32'b0x7f800000 : 32'b0xff800000;  // result is infinity with the correct sign
        end else begin
            // Proceed with multiplication
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1'b1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1'b1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b100) begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        z_exponent <= a_exponent + b_exponent - 127;  // Adjust exponent
        z_sign <= a_sign ^ b_sign;  // Combine signs
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Round the result
        guard_bit <= product[48];
        round_bit <= product[47];
        sticky <= |product[46:0];
        if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
            z_mantissa <= product[46:23] + 1'b1;
        end else begin
            z_mantissa <= product[46:23];
        end
        // Adjust exponent
        if (z_mantissa[23] == 1'b1) begin
            z_mantissa <= z_mantissa >> 1;
            z_exponent <= z_exponent + 1'b1;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b110) begin
        // Format the result in IEEE 754 format
        z <= {z_sign, z_exponent[8:0], z_mantissa};
        // Handle overflow and underflow
        if (z_exponent == 9'b11111111) begin
            z <= (z_sign == 1'b0) ? 32'b0x7f800000 : 32'b0xff800000;  // infinity
        end else if (z_exponent == 9'b0) begin
            z <= (z_sign == 1'b0) ? 32'b0x00000000 : 32'b0x80000000;  // zero
        end
    end
end

endmodule