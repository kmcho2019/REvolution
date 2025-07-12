module float_multi(
    input           clk,
    input           rst,
    input   [31:0]  a,
    input   [31:0]  b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0]  a_exponent, b_exponent, z_exponent;
    reg         a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg         guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
        end else begin
            case (counter)
                3'b000: begin
                    // Extract mantissas, exponents, and sign bits from inputs
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                    counter <= 3'b001;
                end
                3'b001: begin
                    // Handle special cases (NaN, infinity)
                    if (a_exponent == 9'b111111111 || b_exponent == 9'b111111111) begin
                        // Handle infinity
                        if (a_exponent == 9'b111111111 && b_exponent == 9'b111111111) begin
                            z_sign <= a_sign ^ b_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end else if (a_exponent == 9'b111111111) begin
                            z_sign <= a_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end else begin
                            z_sign <= b_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end
                        counter <= 3'b110;
                    end else if (a_exponent == 9'b0 && b_exponent == 9'b0) begin
                        // Handle zero
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 9'b0;
                        z_mantissa <= 23'b0;
                        counter <= 3'b110;
                    end else begin
                        // Normalize mantissas if needed
                        if (a_mantissa[23] == 1'b0) begin
                            a_mantissa <= {1'b1, a_mantissa[22:0]};
                            a_exponent <= a_exponent - 9'b1;
                        end
                        if (b_mantissa[23] == 1'b0) begin
                            b_mantissa <= {1'b1, b_mantissa[22:0]};
                            b_exponent <= b_exponent - 9'b1;
                        end
                        counter <= 3'b010;
                    end
                end
                3'b010: begin
                    // Multiply mantissas and adjust exponent
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent - 9'b127;
                    counter <= 3'b011;
                end
                3'b011: begin
                    // Round result and handle overflow/underflow
                    if (product[49] == 1'b1) begin
                        // Overflow
                        z_exponent <= z_exponent + 9'b1;
                        z_mantissa <= product[48:25];
                    end else if (product[24] == 1'b1) begin
                        // Round
                        z_mantissa <= product[48:25] + 1'b1;
                    end else begin
                        // Underflow
                        z_mantissa <= product[48:25];
                    end
                    counter <= 3'b100;
                end
                3'b100: begin
                    // Format result in IEEE 754 standard
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 3'b000;
                end
                default: begin
                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule