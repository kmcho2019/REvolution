module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals for mantissas, exponents, and signs
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;

// Intermediate product and rounding control bits
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Cycle counter for operation sequencing
reg [2:0] counter;

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Extract inputs during the first clock cycle
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Extract sign, exponent, and mantissa from inputs
        a_sign <= a[31];
        b_sign <= b[31];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_mantissa <= {1'b1, a[22:0]};
        b_mantissa <= {1'b1, b[22:0]};
    end
end

// Handle special cases (NaN, infinity) during the second clock cycle
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Check for NaN (Not a Number) or infinity in either input
        if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
            // Result is NaN if either input is NaN
            z <= 32'h7fc00000; // NaN representation
        end else if (a_exponent == 8'hff || b_exponent == 8'hff) begin
            // Result is infinity if either input is infinity
            z <= (a_sign || b_sign) ? 32'hff800000 : 32'h7f800000; // Negative or positive infinity
        end
    end
end

// Normalize mantissas if needed and multiply during the third clock cycle
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Normalize mantissas (assuming they are already normalized for simplicity)
        product <= a_mantissa * b_mantissa;
        // Calculate the new exponent
        z_exponent <= a_exponent + b_exponent - 127; // Bias adjustment
        z_sign <= a_sign ^ b_sign; // Combine signs
    end
end

// Round the result and adjust the exponent during the fourth clock cycle
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Round the product and adjust the exponent as necessary
        // This is a simplified rounding example and may need additional logic for full IEEE-754 compliance
        if (product[49]) begin
            // If the most significant bit of the product is set, round up
            z_mantissa <= product[48:25] + 1;
            if (z_mantissa == 24'h1000000) begin
                // If rounding causes a carry into the exponent, adjust accordingly
                z_exponent <= z_exponent + 1;
                z_mantissa <= 24'h000000;
            end
        end else begin
            // Otherwise, round down
            z_mantissa <= product[48:25];
        end
        
        // Assemble the final result
        z <= {z_sign, z_exponent, z_mantissa[23:0]};
    end
end

endmodule