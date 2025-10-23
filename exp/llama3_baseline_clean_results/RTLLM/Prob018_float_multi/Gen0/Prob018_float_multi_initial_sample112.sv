module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else if (counter == 0) begin
        // Extract mantissas, exponents, and signs from inputs
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        z_sign <= a_sign ^ b_sign;  // Combine signs
        
        // Handle special cases (NaN, infinity)
        if ((a_exponent == 10'd255 && a_mantissa!= 0) ||
            (b_exponent == 10'd255 && b_mantissa!= 0)) begin
            z <= {32{1'b1}};  // Result is NaN
        end else if (a_exponent == 10'd255 || b_exponent == 10'd255) begin
            z <= {a_sign, 10'd255, 23'd0};  // Result is infinity
        end
        
        // Check for zero inputs
        if ((a_exponent == 0 && a_mantissa == 0) ||
            (b_exponent == 0 && b_mantissa == 0)) begin
            z <= {a_sign, 10'd0, 23'd0};  // Result is zero
        end
        
        counter <= counter + 1;
    end else if (counter == 1) begin
        // Normalize mantissas
        if (a_mantissa[23] == 0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1;
        end
        
        // Multiply mantissas
        product <= {a_mantissa, 24'd0} * {b_mantissa, 24'd0};
        
        counter <= counter + 1;
    end else if (counter == 2) begin
        // Adjust exponent
        z_exponent <= a_exponent + b_exponent - 127;
        
        // Round result
        if (product[49]) begin  // Guard bit
            guard_bit <= 1'b1;
        end
        if (product[48]) begin  // Round bit
            round_bit <= 1'b1;
        end
        if (product[47:0]!= 0) begin  // Sticky bit
            sticky <= 1'b1;
        end
        
        // Adjust mantissa based on rounding
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[48:25] + 1;
        end else begin
            z_mantissa <= product[48:25];
        end
        
        counter <= counter + 1;
    end else if (counter == 3) begin
        // Handle overflow and underflow
        if (z_exponent > 10'd254) begin
            z_exponent <= 10'd255;
            z_mantissa <= 0;
        end else if (z_exponent < 1) begin
            z_exponent <= 0;
            z_mantissa <= 0;
        end
        
        // Format final result
        z <= {z_sign, z_exponent, z_mantissa};
        
        counter <= 0;
    end
end

endmodule