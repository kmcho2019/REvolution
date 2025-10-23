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

// Extract mantissas, exponents, and signs from inputs
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        product <= 0;
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
    end else if (counter == 0) begin
        // Extract mantissas, exponents, and signs
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1;
    end else if (counter == 1) begin
        // Check for special cases (NaN, infinity)
        if (a_exponent == 255 && a_mantissa != 0) begin
            // a is NaN
            z_sign <= a_sign;
            z_exponent <= 255;
            z_mantissa <= a_mantissa;
        end else if (b_exponent == 255 && b_mantissa != 0) begin
            // b is NaN
            z_sign <= b_sign;
            z_exponent <= 255;
            z_mantissa <= b_mantissa;
        end else if (a_exponent == 255 && a_mantissa == 0) begin
            // a is infinity
            z_sign <= a_sign;
            z_exponent <= 255;
            z_mantissa <= 0;
        end else if (b_exponent == 255 && b_mantissa == 0) begin
            // b is infinity
            z_sign <= b_sign;
            z_exponent <= 255;
            z_mantissa <= 0;
        end else begin
            // Normalize mantissas if necessary
            if (a_exponent == 0) begin
                // a is denormalized
                a_mantissa <= a_mantissa << 1;
                a_exponent <= a_exponent - 1;
            end
            if (b_exponent == 0) begin
                // b is denormalized
                b_mantissa <= b_mantissa << 1;
                b_exponent <= b_exponent - 1;
            end
            // Multiply mantissas, combine signs, and adjust exponents
            product <= {a_mantissa, 23'd0} * {b_mantissa, 23'd0};
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 127;
            counter <= counter + 1;
        end
    end else if (counter == 2) begin
        // Round result and adjust exponent
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];
        if (guard_bit && (round_bit || sticky)) begin
            // Round up
            product <= product + 50'd1;
        end
        z_mantissa <= product[48:25];
        z_exponent <= z_exponent + 1;
        counter <= counter + 1;
    end else if (counter == 3) begin
        // Format final result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 0;
    end
end

endmodule