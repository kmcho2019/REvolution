module float_multi (
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
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        a_exponent <= 9'b0;
        b_exponent <= 9'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
    end else if (counter == 3'b000) begin
        // Extract mantissas, exponents, and signs from inputs
        a_sign <= a[31];
        b_sign <= b[31];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_mantissa <= {1'b1, a[22:0]}; // Implicit leading 1 for normalized numbers
        b_mantissa <= {1'b1, b[22:0]};
        counter <= counter + 1;
    end else if (counter == 3'b001) begin
        // Handle special cases (NaN, infinity)
        if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
            if ((a_exponent == 9'b111111111) && (a_mantissa != 24'b0)) begin
                // NaN
                z <= 32'b11111111_10000000_00000000_00000000_00000000;
            end else if ((b_exponent == 9'b111111111) && (b_mantissa != 24'b0)) begin
                // NaN
                z <= 32'b11111111_10000000_00000000_00000000_00000000;
            end else if (a_sign != b_sign) begin
                // Different signs, result is negative infinity
                z <= {1'b1, 8'b11111111, 23'b0};
            end else begin
                // Same signs, result is positive infinity
                z <= {1'b0, 8'b11111111, 23'b0};
            end
        end else begin
            counter <= counter + 1;
        end
    end else if (counter == 3'b010) begin
        // Normalize mantissas if necessary
        if (a_mantissa[23] == 1'b0) begin
            // Normalize a
            a_mantissa <= {a_mantissa[22:0], 1'b0};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 1'b0) begin
            // Normalize b
            b_mantissa <= {b_mantissa[22:0], 1'b0};
            b_exponent <= b_exponent - 1;
        end
        counter <= counter + 1;
    end else if (counter == 3'b011) begin
        // Multiply mantissas, adjust signs and exponents
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent + 1;
        z_sign <= a_sign ^ b_sign;
        counter <= counter + 1;
    end else if (counter == 3'b100) begin
        // Rounding and adjustment
        guard_bit <= product[24];
        round_bit <= product[25];
        sticky <= |product[26:0];
        if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
            z_mantissa <= {product[23:0]} + 1;
            if (z_mantissa[23] == 1'b1) begin
                z_exponent <= z_exponent + 1;
                z_mantissa <= {z_mantissa[22:0], 1'b0};
            end
        end else begin
            z_mantissa <= product[23:0];
        end
        counter <= counter + 1;
    end else if (counter == 3'b101) begin
        // Output generation
        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
        counter <= 3'b000; // Reset counter for next operation
    end
end

endmodule