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

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
    end else begin
        case(counter)
            3'b000: counter <= 3'b001;
            3'b001: counter <= 3'b010;
            3'b010: counter <= 3'b011;
            3'b011: counter <= 3'b100;
            3'b100: counter <= 3'b000;
            default: counter <= 3'b000;
        endcase
    end
end

// Input processing: Extract mantissas, exponents, and signs
always @(posedge clk) begin
    if(counter == 3'b000) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Special cases handling: NaN and infinity
always @(posedge clk) begin
    if(counter == 3'b001) begin
        if((a_exponent == 9'b11111111 && a_mantissa!= 0) || (b_exponent == 9'b11111111 && b_mantissa!= 0)) begin
            // Handle NaN or infinity
            z_exponent <= 9'b11111111;
            z_mantissa <= 24'b0;
            z_sign <= a_sign ^ b_sign;
        end
    end
end

// Normalization and multiplication
always @(posedge clk) begin
    if(counter == 3'b010) begin
        // Multiply mantissas
        product <= {a_mantissa, 26'b0} * {b_mantissa, 26'b0};
        // Combine signs
        z_sign <= a_sign ^ b_sign;
        // Adjust exponents
        z_exponent <= a_exponent + b_exponent - 127;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if(counter == 3'b011) begin
        // Extract guard, round, and sticky bits
        guard_bit <= product[25];
        round_bit <= product[24];
        sticky <= |product[23:0];
        // Round the result
        if((round_bit == 1'b1) && (guard_bit || sticky)) begin
            z_mantissa <= product[49:26] + 1;
        end else begin
            z_mantissa <= product[49:26];
        end
        // Adjust exponent if necessary
        if(z_mantissa[23] == 1'b1) begin
            z_exponent <= z_exponent + 1;
            z_mantissa <= z_mantissa >> 1;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if(counter == 3'b100) begin
        // Format the result according to IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule