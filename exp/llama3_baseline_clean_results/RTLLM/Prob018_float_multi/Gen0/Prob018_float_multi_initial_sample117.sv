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

// Input processing and extraction of mantissas, exponents, and sign bits
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
        a_mantissa <= 0;
        b_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
    end else if(counter == 3'b000) begin
        // Extract mantissas, exponents, and sign bits
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        counter <= counter + 1'b1;
    end
end

// Special cases handling
always @(posedge clk) begin
    if(counter == 3'b001) begin
        // Check for NaN and infinity
        if((a_exponent == 10'b11111111) || (b_exponent == 10'b11111111)) begin
            z <= 32'b1; // Result is NaN or infinity
        end
        counter <= counter + 1'b1;
    end
end

// Normalization and multiplication
always @(posedge clk) begin
    if(counter == 3'b010) begin
        // Normalize mantissas if needed
        if(a_mantissa[23] == 1'b0) begin
            a_mantissa <= a_mantissa << 1;
            a_exponent <= a_exponent - 1'b1;
        end
        if(b_mantissa[23] == 1'b0) begin
            b_mantissa <= b_mantissa << 1;
            b_exponent <= b_exponent - 1'b1;
        end
        // Multiply mantissas
        product <= a_mantissa * b_mantissa;
        counter <= counter + 1'b1;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if(counter == 3'b011) begin
        // Round the result
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= product[47:0]!= 0;
        if((guard_bit && (round_bit || sticky)) || (guard_bit && a_sign == b_sign)) begin
            product <= product + 1;
        end
        // Adjust the exponent
        z_exponent <= a_exponent + b_exponent + 1'b1;
        z_mantissa <= product[49:26];
        counter <= counter + 1'b1;
    end
end

// Output generation
always @(posedge clk) begin
    if(counter == 3'b100) begin
        // Format the result in IEEE 754 standard
        z_sign <= a_sign ^ b_sign;
        z_exponent <= z_exponent - 10'b01111111; // Bias
        if(z_exponent > 10'b11111110) begin
            z <= 32'b1; // Overflow
        end else if(z_exponent < 10'b1) begin
            z <= 32'b0; // Underflow
        end else begin
            z <= {z_sign, z_exponent, z_mantissa};
        end
        counter <= 3'b000;
    end
end

endmodule