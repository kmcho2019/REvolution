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

// Extract mantissas, exponents, and sign bits
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end else if (counter == 0) begin
        // Handle special cases
        if ((a_exponent == 10'b11111111 && a_mantissa != 0) ||
            (b_exponent == 10'b11111111 && b_mantissa != 0)) begin
            // NaN or infinity
            z_sign <= 1'b0;
            z_exponent <= 10'b11111111;
            z_mantissa <= 24'b0;
            counter <= 3;
        end else if ((a_exponent == 10'b11111111 && a_mantissa == 0) ||
                     (b_exponent == 10'b11111111 && b_mantissa == 0)) begin
            // Infinity
            z_sign <= a_sign ^ b_sign;
            z_exponent <= 10'b11111111;
            z_mantissa <= 24'b0;
            counter <= 3;
        end else begin
            counter <= counter + 1;
        end
    end else if (counter == 1) begin
        // Normalize mantissas
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {1'b1, a_mantissa[22:0]};
            a_exponent <= a_exponent - 1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {1'b1, b_mantissa[22:0]};
            b_exponent <= b_exponent - 1;
        end
        counter <= counter + 1;
    end else if (counter == 2) begin
        // Multiply mantissas
        product <= a_mantissa * b_mantissa;
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 127;
        counter <= counter + 1;
    end else if (counter == 3) begin
        // Round and adjust exponent
        guard_bit <= product[49];
        round_bit <= product[48];
        sticky <= |product[47:0];
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= product[47:24] + 1;
            if (z_mantissa[23] == 1'b1) begin
                z_mantissa <= {1'b0, z_mantissa[22:0]};
                z_exponent <= z_exponent + 1;
            end
        end else begin
            z_mantissa <= product[47:24];
        end
        counter <= 0;
    end
end

// Format output
always @(posedge clk) begin
    if (rst) begin
        z <= 32'b0;
    end else if (counter == 0) begin
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule