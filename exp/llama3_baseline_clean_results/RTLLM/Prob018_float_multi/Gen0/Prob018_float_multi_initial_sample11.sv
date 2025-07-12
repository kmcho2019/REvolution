module float_multi(
    input clk,    // Clock signal
    input rst,    // Reset signal (active high)
    input [31:0] a,    // First operand in IEEE 754 format
    input [31:0] b,    // Second operand in IEEE 754 format
    output reg [31:0] z // Result of the multiplication in IEEE 754 format
);

reg [2:0] counter;    // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa;    // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent;    // Exponents of input and output numbers
reg a_sign, b_sign, z_sign;    // Sign bits for inputs and output
reg [49:0] product;    // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky;    // Rounding control bits

// Initialize counter to zero on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;    // Reset output to zero on reset
    end
    else begin
        if (counter == 3'b111) begin
            // Operation complete, stay in this state
            counter <= 3'b111;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

// Extract mantissas, exponents, and signs from inputs
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Input processing
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end
end

// Handle special cases (NaN, infinity)
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Check for NaN or infinity
        if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
            // NaN or infinity handling, for simplicity, let's just propagate NaN or infinity
            if (a_exponent == 9'b111111111) begin
                z <= a;
            end
            else if (b_exponent == 9'b111111111) begin
                z <= b;
            end
            counter <= 3'b111;    // Operation complete
        end
    end
end

// Normalize mantissas if needed and multiply
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Normalize and multiply
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        z_exponent <= a_exponent + b_exponent - 127;    // Adjust exponent
        z_sign <= a_sign ^ b_sign;    // Calculate sign of result
    end
end

// Round and adjust result
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Round and adjust
        {guard_bit, round_bit, sticky} <= product[48:46];
        if ((round_bit == 1'b1) && (guard_bit == 1'b0) && (sticky == 1'b0)) begin
            // Round to nearest even
            product[47:0] <= product[47:0] + 1;
        end
        // Adjust for overflow or underflow
        if (z_exponent > 254) begin
            // Overflow
            z_exponent <= 255;
            z_mantissa <= 0;
        end
        else if (z_exponent < 1) begin
            // Underflow, for simplicity, let's just set to zero
            z_exponent <= 0;
            z_mantissa <= 0;
        end
        else begin
            // Normalize result
            z_mantissa <= product[46:23];
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Format output in IEEE 754 standard
        z <= {z_sign, z_exponent[7:0], z_mantissa};
        counter <= 3'b111;    // Operation complete
    end
end

endmodule