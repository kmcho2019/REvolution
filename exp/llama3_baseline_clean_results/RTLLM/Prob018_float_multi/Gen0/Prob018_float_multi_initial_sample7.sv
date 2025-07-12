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
        counter <= 3'b000;
        z <= 32'd0;
        z_exponent <= 10'd0;
        z_mantissa <= 24'd0;
        z_sign <= 1'b0;
    end else if (counter == 3'b000) begin
        // Extract mantissas, exponents, and sign bits
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
        counter <= counter + 1'b1;
    end else if (counter == 3'b001) begin
        // Handle special cases
        if ((a_exponent == 10'd255 && a_mantissa != 24'd0) || (b_exponent == 10'd255 && b_mantissa != 24'd0)) begin
            // NaN
            z <= 32'd0;
        end else if (a_exponent == 10'd255 || b_exponent == 10'd255) begin
            // Infinity
            z_exponent <= 10'd255;
            z_mantissa <= 24'd0;
            if (a_sign || b_sign) begin
                z_sign <= 1'b1;
            end else begin
                z_sign <= 1'b0;
            end
        end else begin
            // Normalize mantissas
            if (a_mantissa[23] == 1'b0) begin
                a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                a_exponent <= a_exponent - 1'b1;
            end
            if (b_mantissa[23] == 1'b0) begin
                b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                b_exponent <= b_exponent - 1'b1;
            end
            counter <= counter + 1'b1;
        end
    end else if (counter == 3'b010) begin
        // Multiply mantissas
        product <= a_mantissa * b_mantissa;
        // Combine signs
        if (a_sign != b_sign) begin
            z_sign <= 1'b1;
        end else begin
            z_sign <= 1'b0;
        end
        // Adjust exponents
        z_exponent <= a_exponent + b_exponent - 10'd127;
        counter <= counter + 1'b1;
    end else if (counter == 3'b011) begin
        // Round and adjust
        guard_bit <= product[48];
        round_bit <= product[47];
        sticky <= product[46:0] != 50'd0;
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[46:23] + 1'b1;
        end else begin
            z_mantissa <= product[46:23];
        end
        if (z_mantissa[23] == 1'b1) begin
            z_exponent <= z_exponent + 1'b1;
            z_mantissa <= z_mantissa >> 1;
        end
        // Handle overflow and underflow
        if (z_exponent >= 10'd255) begin
            z_exponent <= 10'd255;
            z_mantissa <= 24'd0;
        end else if (z_exponent < 10'd1) begin
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;
        end
        counter <= counter + 1'b1;
    end else begin
        // Output generation
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 3'b000;
    end
end

endmodule