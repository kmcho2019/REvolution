module float_multi(
    input         clk,
    input         rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        case (counter)
            3'b000: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= {1'b1, a[22:0]};
                b_mantissa <= {1'b1, b[22:0]};
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    z <= (a_exponent == 9'b11111111)? a : b;
                end
                counter <= 3'b001;
            end
            3'b001: begin
                // Normalize mantissas if necessary
                if (a_exponent!= 0) begin
                    a_mantissa <= a_mantissa << (8 - a_exponent);
                end
                if (b_exponent!= 0) begin
                    b_mantissa <= b_mantissa << (8 - b_exponent);
                end
                counter <= 3'b010;
            end
            3'b010: begin
                // Multiply mantissas, combine signs, adjust exponents
                product <= a_mantissa * b_mantissa;
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= 3'b011;
            end
            3'b011: begin
                // Round and adjust result
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // Format final result in IEEE 754 format
                if (z_exponent > 254) begin
                    // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else if (z_exponent < -126) begin
                    // Underflow
                    z <= {z_sign, 8'b00000000, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa[22:0]};
                end
                counter <= 3'b000;
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule