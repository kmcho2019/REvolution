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

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
    end else if (counter < 3'd7) begin
        counter <= counter + 1'd1;
    end else begin
        counter <= 0;
    end
end

// Input Processing
always @(posedge clk) begin
    if (counter == 3'd1) begin
        // Extract mantissas, exponents, and sign bits from inputs a and b
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
    end
end

// Special Cases Handling
always @(posedge clk) begin
    if (counter == 3'd2) begin
        // Check for NaN (Not a Number) or infinity
        if ((a_exponent == 9'd255 && a_mantissa != 0) || (b_exponent == 9'd255 && b_mantissa != 0)) begin
            // Result is NaN
            z_mantissa <= 0;
            z_exponent <= 9'd255;
            z_sign <= 1'b0;
        end else if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
            // Result is infinity
            z_mantissa <= 0;
            z_exponent <= 9'd255;
            z_sign <= a_sign || b_sign;
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'd3) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1'd1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1'd1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'd4) begin
        // Multiply mantissas
        product <= {a_mantissa, 24'd0} * {b_mantissa, 24'd0};
        // Combine signs
        z_sign <= a_sign ^ b_sign;
        // Adjust exponents
        z_exponent <= a_exponent + b_exponent - 10'd127;
    end
end

// Rounding and Adjustment
always @(posedge clk) begin
    if (counter == 3'd5) begin
        // Round the result
        guard_bit <= product[23];
        round_bit <= product[22];
        sticky <= |product[21:0];
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[49:26] + 1'd1;
        end else begin
            z_mantissa <= product[49:26];
        end
        // Adjust exponent
        if (z_mantissa[23] == 1'b1) begin
            z_mantissa <= {z_mantissa[22:0], 1'b0};
            z_exponent <= z_exponent + 1'd1;
        end
    end
end

// Output Generation
always @(posedge clk) begin
    if (counter == 3'd6) begin
        // Format result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule