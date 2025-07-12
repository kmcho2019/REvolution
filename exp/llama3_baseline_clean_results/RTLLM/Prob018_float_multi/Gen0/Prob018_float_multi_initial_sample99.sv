module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        if (counter < 3'b111) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 3'b000;
        end
    end
end

// Input Processing
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Extract mantissas, exponents, and sign bits from inputs
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
    if (counter == 3'b010) begin
        // Check for NaN or infinity
        if ((a_exponent == 10'd255 && a_mantissa != 24'd0) || (b_exponent == 10'd255 && b_mantissa != 24'd0)) begin
            // Handle NaN or infinity according to IEEE 754 standard
            z_sign <= a_sign || b_sign;
            z_exponent <= 10'd255;
            z_mantissa <= 24'd0;
        end else if (a_exponent == 10'd255 || b_exponent == 10'd255) begin
            // Handle infinity
            z_sign <= a_sign || b_sign;
            z_exponent <= 10'd255;
            z_mantissa <= 24'd0;
        end else begin
            // Proceed with multiplication
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 10'd127;
        end
    end
end

// Normalization and Multiplication
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize product if necessary
        if (product[49]) begin
            product <= product >> 1;
            z_exponent <= z_exponent + 1'b1;
        end
        
        // Extract mantissa from product
        z_mantissa <= product[23:0];
    end
end

// Rounding and Adjustment
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Determine rounding bits
        guard_bit <= product[22];
        round_bit <= product[21];
        sticky <= |product[20:0];
        
        // Round the result
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= z_mantissa + 1'b1;
        end
        
        // Adjust exponent if necessary
        if (z_mantissa[23]) begin
            z_mantissa <= z_mantissa >> 1;
            z_exponent <= z_exponent + 1'b1;
        end
    end
end

// Output Generation
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Format the final result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule