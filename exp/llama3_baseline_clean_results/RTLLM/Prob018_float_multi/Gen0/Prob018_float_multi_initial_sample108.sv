module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialize the counter on reset
always @(posedge rst) begin
    counter <= 3'b000;
end

// Input processing
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Extract mantissas, exponents, and sign bits
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1'b1;
    end
    // Special cases handling
    else if (counter == 3'b001) begin
        if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
            // NaN or infinity
            if (a_exponent == 9'b11111111)
                z <= a;
            else
                z <= b;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    // Normalization
    else if (counter == 3'b010) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0)
            a_mantissa <= {1'b1, a_mantissa[22:0]};
        if (b_mantissa[23] == 1'b0)
            b_mantissa <= {1'b1, b_mantissa[22:0]};
        counter <= counter + 1'b1;
    end
    // Multiplication
    else if (counter == 3'b011) begin
        // Multiply mantissas, combine signs, and adjust exponents
        product <= a_mantissa * b_mantissa;
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 9'b01111011; // Subtract bias
        counter <= counter + 1'b1;
    end
    // Rounding and adjustment
    else if (counter == 3'b100) begin
        // Round the result and adjust the exponent
        if (product[49] == 1'b1) begin
            // Round up
            z_mantissa <= product[48:25] + 1'b1;
        end
        else begin
            // Round down
            z_mantissa <= product[48:25];
        end
        // Adjust the exponent for overflow or underflow
        if (z_mantissa[23] == 1'b1)
            z_exponent <= z_exponent + 1'b1;
        counter <= counter + 1'b1;
    end
    // Output generation
    else if (counter == 3'b101) begin
        // Format the final result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
        counter <= 3'b000;
    end
end

endmodule