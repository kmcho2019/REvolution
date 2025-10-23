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

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                // Handle special cases (NaN, infinity)
                if ((a_exponent == 9'b255 && a_mantissa != 23'b0) || (b_exponent == 9'b255 && b_mantissa != 23'b0)) begin
                    z <= 32'b1; // NaN
                end else if ((a_exponent == 9'b255 && a_mantissa == 23'b0) || (b_exponent == 9'b255 && b_mantissa == 23'b0)) begin
                    z <= 32'b1; // Infinity
                end
                counter <= counter + 1;
            end
            3'b001: begin
                // Normalize mantissas
                if (a_exponent != 9'b0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                end
                if (b_exponent != 9'b0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                end
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;
                counter <= counter + 1;
            end
            3'b010: begin
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 9'b127;
                // Round and adjust
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[2:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= counter + 1;
            end
            3'b011: begin
                // Generate output in IEEE 754 format
                z <= {z_sign, z_exponent, z_mantissa[23:0]};
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule