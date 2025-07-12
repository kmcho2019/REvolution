module float_multi(clk, rst, a, b, z);

input clk, rst;
input [31:0] a, b;
output reg [31:0] z;

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponent is 8 bits in IEEE 754
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Extract mantissas, exponents, and sign bits during the first clock cycle
always @(posedge clk) begin
    if (counter == 3'b001) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Handle special cases like NaN and infinity
always @(posedge clk) begin
    if (counter == 3'b010) begin
        if ((a_exponent == 9'b255 && a_mantissa != 0) || (b_exponent == 9'b255 && b_mantissa != 0)) begin
            // NaN
            z <= 32'b1_11111111_00000000000000000000000;
        end else if ((a_exponent == 9'b255 && a_mantissa == 0) || (b_exponent == 9'b255 && b_mantissa == 0)) begin
            // Infinity
            if (a_exponent == 9'b255) begin
                z_sign <= a_sign;
            end else begin
                z_sign <= b_sign;
            end
            z <= {z_sign, 8'b11111111, 23'b0};
        end
    end
end

// Normalize mantissas if needed
always @(posedge clk) begin
    if (counter == 3'b011) begin
        if (a_mantissa[23] == 0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1'b1;
        end
        
        if (b_mantissa[23] == 0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1'b1;
        end
    end
end

// Multiply mantissas and combine signs
always @(posedge clk) begin
    if (counter == 3'b100) begin
        z_sign <= a_sign ^ b_sign;
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent - 127; // Bias for single precision
    end
end

// Round and adjust
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Extract guard, round, and sticky bits
        guard_bit <= product[48];
        round_bit <= product[47];
        sticky <= |product[46:0];
        
        // Round to nearest even
        if (round_bit == 1'b1 && (guard_bit == 1'b1 || sticky == 1'b1)) begin
            z_mantissa <= product[47:24] + 1'b1;
        end else begin
            z_mantissa <= product[47:24];
        end
        
        // Check for overflow and adjust exponent if necessary
        if (z_mantissa[23] == 1'b1) begin
            z_exponent <= z_exponent + 1'b1;
            z_mantissa <= {1'b0, z_mantissa[22:0]};
        end
    end
end

// Generate output
always @(posedge clk) begin
    if (counter == 3'b110) begin
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule