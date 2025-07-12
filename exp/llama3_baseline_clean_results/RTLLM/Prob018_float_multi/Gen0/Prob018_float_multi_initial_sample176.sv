module float_multi(
    input clk, 
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals for counter, mantissas, exponents, signs, and intermediate product
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization and input processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
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
        // Handle special cases (NaN, infinity)
        if ((a_exponent == 255 && a_mantissa != 0) || (b_exponent == 255 && b_mantissa != 0)) begin
            z <= 32'h7fc00000; // NaN
        end else if ((a_exponent == 255 && a_mantissa == 0) || (b_exponent == 255 && b_mantissa == 0)) begin
            z <= (a_sign || b_sign) ? 32'bf800000 : 32'7f800000; // Infinity
        end else begin
            // Normalize mantissas if needed
            if (a_exponent == 0) begin
                a_mantissa <= {1'b1, a_mantissa};
                a_exponent <= a_exponent - 1;
            end
            if (b_exponent == 0) begin
                b_mantissa <= {1'b1, b_mantissa};
                b_exponent <= b_exponent - 1;
            end
            // Multiply mantissas and adjust exponent
            product <= (a_mantissa * b_mantissa);
            z_exponent <= a_exponent + b_exponent - 127;
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1;
        end
    end else if (counter == 2) begin
        // Round and adjust result
        guard_bit <= product[47];
        round_bit <= product[46];
        sticky <= |product[45:0];
        if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
            z_mantissa <= product[46:23] + 1;
        end else begin
            z_mantissa <= product[46:23];
        end
        if (z_mantissa[23]) begin
            z_exponent <= z_exponent + 1;
            z_mantissa <= z_mantissa >> 1;
        end
        // Handle overflow and underflow
        if (z_exponent > 255) begin
            z <= (z_sign) ? 32'bf800000 : 32'7f800000; // Infinity
        end else if (z_exponent < 1) begin
            z <= (z_sign) ? 32'bf000000 : 32'7f000000; // Zero
        end else begin
            z <= {z_sign, z_exponent + 127, z_mantissa};
        end
        counter <= 0;
    end
end

endmodule