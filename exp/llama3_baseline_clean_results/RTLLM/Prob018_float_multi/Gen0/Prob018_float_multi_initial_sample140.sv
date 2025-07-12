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

// Extract mantissas, exponents, and sign bits from inputs
always @(posedge clk) begin
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
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1;
    end else if (counter == 1) begin
        // Handle special cases (NaN, infinity)
        if ((a_exponent == 10'd255 && a_mantissa != 0) || (b_exponent == 10'd255 && b_mantissa != 0)) begin
            z <= 32'h7fc00000; // NaN
        end else if ((a_exponent == 10'd255 && a_mantissa == 0) || (b_exponent == 10'd255 && b_mantissa == 0)) begin
            z <= 32'h7f800000; // infinity
        end else begin
            // Normalize mantissas if needed
            if (a_exponent == 0) begin
                a_mantissa <= {1'b1, a_mantissa};
                a_exponent <= a_exponent + 1;
            end
            if (b_exponent == 0) begin
                b_mantissa <= {1'b1, b_mantissa};
                b_exponent <= b_exponent + 1;
            end
            counter <= counter + 1;
        end
    end else if (counter == 2) begin
        // Multiply mantissas
        product <= a_mantissa * b_mantissa;
        // Combine signs and adjust exponents
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 10'd127;
        counter <= counter + 1;
    end else if (counter == 3) begin
        // Round and adjust result
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[47:24] + 1;
        end else begin
            z_mantissa <= product[47:24];
        end
        // Handle overflow and underflow
        if (z_exponent > 10'd255) begin
            z <= 32'h7f800000; // infinity
        end else if (z_exponent < 10'd1) begin
            z <= 32'h00000000; // zero
        end else begin
            z <= {z_sign, z_exponent, z_mantissa};
        end
        counter <= 0;
    end
end

endmodule