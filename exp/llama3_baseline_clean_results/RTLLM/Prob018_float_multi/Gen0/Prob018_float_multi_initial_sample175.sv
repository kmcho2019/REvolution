module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [9:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Extract mantissas, exponents, and sign bits from inputs during the first clock cycle
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        product <= 0;
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
    end else if (counter == 3'b000) begin
        // Extract mantissas, exponents, and sign bits
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1;
    end else if (counter == 3'b001) begin
        // Check for special cases (NaN, infinity)
        if ((a_exponent == 10'b11111111) || (b_exponent == 10'b11111111)) begin
            // Handle NaN or infinity
            if (a_exponent == 10'b11111111) begin
                z <= a; // If a is NaN or infinity, result is a
            end else begin
                z <= b; // If b is NaN or infinity, result is b
            end
            counter <= 3'b111; // Jump to the final state
        end else begin
            // Normalize mantissas if necessary
            if (a_exponent!= 0) begin
                a_mantissa <= {1'b1, a_mantissa}; // Implicit 1 in the mantissa
            end
            if (b_exponent!= 0) begin
                b_mantissa <= {1'b1, b_mantissa}; // Implicit 1 in the mantissa
            end
            counter <= counter + 1;
        end
    end else if (counter == 3'b010) begin
        // Multiply the mantissas, combine the signs, and adjust the exponents
        product <= a_mantissa * b_mantissa;
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 10'b01111111; // Subtract bias
        counter <= counter + 1;
    end else if (counter == 3'b011) begin
        // Round the result and adjust the exponent
        guard_bit <= product[0];
        round_bit <= product[1];
        sticky <= |product[2:0];
        if ((guard_bit == 1) && ((round_bit == 1) || sticky == 1)) begin
            z_mantissa <= product[49:24] + 1;
            if (z_mantissa[23] == 1) begin
                z_exponent <= z_exponent + 1;
                z_mantissa <= 0; // Mantissa becomes 0 after rounding
            end
        end else begin
            z_mantissa <= product[49:24];
        end
        counter <= counter + 1;
    end else if (counter == 3'b100) begin
        // Format the final result in IEEE 754 standard
        if (z_exponent == 0) begin
            // Underflow
            z <= {z_sign, 10'b00000000, z_mantissa};
        end else if (z_exponent == 10'b11111111) begin
            // Overflow
            z <= {z_sign, 10'b11111111, 24'b0};
        end else begin
            // Normal result
            z <= {z_sign, z_exponent, z_mantissa};
        end
        counter <= 3'b111; // Final state
    end
end

endmodule