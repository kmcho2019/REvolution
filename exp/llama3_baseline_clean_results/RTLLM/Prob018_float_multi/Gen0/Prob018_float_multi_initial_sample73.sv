module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization and Input Processing
always @(*) begin
    if (rst) begin
        counter <= 0;
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
    end else if (counter == 0) begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1;
    end
end

// Special Cases Handling
always @(*) begin
    if ((a_exponent == 8'hFF && a_mantissa != 0) || (b_exponent == 8'hFF && b_mantissa != 0)) begin
        // NaN handling
        z <= 32'h7FC00000;
    end else if ((a_exponent == 8'hFF && a_mantissa == 0) || (b_exponent == 8'hFF && b_mantissa == 0)) begin
        // Infinity handling
        z <= 32'h7F800000;
    end
end

// Normalization and Multiplication
always @(posedge clk) begin
    if (counter == 1) begin
        // Unbiased exponents
        reg [7:0] unbiased_a_exponent, unbiased_b_exponent;
        unbiased_a_exponent <= a_exponent - 8'd127;
        unbiased_b_exponent <= b_exponent - 8'd127;
        
        // Normalize mantissas and combine signs
        reg combined_sign;
        combined_sign <= a_sign ^ b_sign;
        
        // Multiply mantissas (including implied leading 1)
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        
        // Calculate new exponent
        reg [9:0] new_exponent;
        new_exponent <= unbiased_a_exponent + unbiased_b_exponent + 10'd127;
        
        counter <= counter + 1;
    end
end

// Rounding and Adjustment
always @(posedge clk) begin
    if (counter == 2) begin
        // Rounding control bits
        guard_bit <= product[48];
        round_bit <= product[47];
        sticky <= |product[46:0];
        
        // Round result
        reg [23:0] rounded_mantissa;
        if (guard_bit && (round_bit || sticky)) begin
            rounded_mantissa <= z_mantissa + 1;
        end else begin
            rounded_mantissa <= z_mantissa;
        end
        
        // Adjust exponent if necessary
        if (rounded_mantissa[23]) begin
            // Overflow
            z_exponent <= z_exponent + 1;
            rounded_mantissa <= rounded_mantissa >> 1;
        end
        
        z_mantissa <= rounded_mantissa;
        z_sign <= combined_sign;
        z_exponent <= new_exponent[7:0];
        
        counter <= counter + 1;
    end
end

// Output Generation
always @(posedge clk) begin
    if (counter == 3) begin
        // Format result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 0;
    end
end

endmodule