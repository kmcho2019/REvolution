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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Handle special cases (NaN, infinity)
                if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
                    z <= (a_exponent == 9'd255) ? a : b;
                end
                counter <= counter + 1;
            end
            3'd1: begin
                // Normalize mantissas if needed
                if (a_exponent != 0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= a_exponent - 1;
                end
                if (b_exponent != 0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'd2: begin
                // Multiply mantissas and combine signs
                product <= (a_mantissa * b_mantissa);
                z_sign <= a_sign ^ b_sign;
                // Adjust exponents
                z_exponent <= a_exponent + b_exponent + 1;
                counter <= counter + 1;
            end
            3'd3: begin
                // Round result and adjust exponent
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                    if (z_mantissa == 24'd0) begin
                        z_exponent <= z_exponent + 1;
                    end
                end else begin
                    z_mantissa <= product[47:24];
                end
                // Format result in IEEE 754 standard
                z <= {z_sign, z_exponent[7:0], z_mantissa};
                counter <= 3'd0;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule