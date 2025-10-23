module float_multi(
    input  clk,
    input  rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0]  a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else if (counter == 3'b111) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Extract input components during the first clock cycle
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Extract sign bits
        a_sign <= a[31];
        b_sign <= b[31];

        // Extract exponents
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];

        // Extract mantissas
        a_mantissa <= {1'b1, a[22:0]};
        b_mantissa <= {1'b1, b[22:0]};
    end
end

// Handle special cases like NaN and infinity
always @(posedge clk) begin
    if (counter == 3'b001) begin
        if ((a_exponent == 8'b11111111) || (b_exponent == 8'b11111111)) begin
            // Handle NaN or infinity
            z <= (a_exponent == 8'b11111111) ? a : b;
        end else if ((a_exponent == 8'b00000000) || (b_exponent == 8'b00000000)) begin
            // Handle zero or denormal
            z_exponent <= 8'b00000000;
            z_mantissa <= 24'b0;
            z_sign <= a_sign ^ b_sign;
        end
    end
end

// Normalize mantissas if needed
always @(posedge clk) begin
    if (counter == 3'b010) begin
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {a_mantissa[22:0], 1'b0};
            a_exponent <= a_exponent - 1'b1;
        end

        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {b_mantissa[22:0], 1'b0};
            b_exponent <= b_exponent - 1'b1;
        end
    end
end

// Multiply mantissas, combine signs, and adjust exponents
always @(posedge clk) begin
    if (counter == 3'b011) begin
        product <= a_mantissa * b_mantissa;
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 8'b01111111; // Bias for single precision
    end
end

// Round the result and adjust the exponent
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Determine guard bit, round bit, and sticky bit
        guard_bit <= product[23];
        round_bit <= product[22];
        sticky <= |product[21:0];

        // Round the result
        if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
            z_mantissa <= product[49:26] + 1'b1;
        end else begin
            z_mantissa <= product[49:26];
        end

        // Adjust the exponent if necessary
        if (z_mantissa[23] == 1'b1) begin
            z_exponent <= z_exponent + 1'b1;
            z_mantissa <= z_mantissa >> 1;
        end
    end
end

// Generate the final output
always @(posedge clk) begin
    if (counter == 3'b101) begin
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
    end
end

endmodule