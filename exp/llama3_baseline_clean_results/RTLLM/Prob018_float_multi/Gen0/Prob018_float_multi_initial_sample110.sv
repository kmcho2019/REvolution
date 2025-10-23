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
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else if (counter == 3'b111) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Extract mantissas, exponents, and signs of inputs (Step 1)
always @(posedge clk) begin
    if (counter == 3'b000) begin
        a_sign <= a[31];
        b_sign <= b[31];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_mantissa <= {1'b1, a[22:0]};
        b_mantissa <= {1'b1, b[22:0]};
    end
end

// Special cases handling: NaN and infinity (Step 2)
always @(posedge clk) begin
    if (counter == 3'b001) begin
        if ((a_exponent == 9'd255) && (a_mantissa != 24'd0)) begin
            // a is NaN
            z <= 32'd0; // Set to NaN
        end else if ((b_exponent == 9'd255) && (b_mantissa != 24'd0)) begin
            // b is NaN
            z <= 32'd0; // Set to NaN
        end else if ((a_exponent == 9'd255) && (a_mantissa == 24'd0) && (b_exponent == 9'd255) && (b_mantissa == 24'd0)) begin
            // Both are infinity
            if (a_sign == b_sign) begin
                z <= {a_sign, 8'd255, 23'd0}; // Positive infinity
            end else begin
                z <= {1'b0, 8'd255, 23'd0}; // Negative infinity
            end
        end
    end
end

// Normalize mantissas if needed and multiply (Step 3)
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Assuming normalization is done, we proceed with multiplication
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent - 127;
        z_sign <= a_sign ^ b_sign;
    end
end

// Rounding and adjustment (Step 4)
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Rounding logic (simplified for demonstration)
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];
        if ((guard_bit && (round_bit || sticky)) || (product[49:23] != 0)) begin
            z_mantissa <= product[49:26] + 1'b1;
        end else begin
            z_mantissa <= product[49:26];
        end
        // Exponent adjustment due to rounding
        if (z_mantissa[23]) begin
            z_exponent <= z_exponent + 1'b1;
            z_mantissa <= z_mantissa >> 1;
        end
    end
end

// Output formatting (Step 5)
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Handle overflow
        if (z_exponent > 9'd254) begin
            z <= {z_sign, 8'd255, 23'd0}; // Infinity
        end else if (z_exponent < 1) begin
            // Underflow, handling not fully implemented for simplicity
            z <= {z_sign, 8'd0, z_mantissa[22:0]};
        end else begin
            z <= {z_sign, z_exponent, z_mantissa[22:0]};
        end
    end
end

endmodule