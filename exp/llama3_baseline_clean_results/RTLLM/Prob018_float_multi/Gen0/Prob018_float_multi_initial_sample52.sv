module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end else begin
            case (counter)
                3'b000: begin
                    // Extract mantissas, exponents, and sign bits
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Handle special cases
                    if ((a_exponent == 10'b11111111 && a_mantissa != 0) || (b_exponent == 10'b11111111 && b_mantissa != 0)) begin
                        // NaN
                        z <= 32'h7fc00000;
                    end else if ((a_exponent == 10'b11111111 && a_mantissa == 0) || (b_exponent == 10'b11111111 && b_mantissa == 0)) begin
                        // Infinity
                        z <= 32'b7f800000;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                3'b001: begin
                    // Normalize mantissas
                    if (a_exponent != 0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                    end
                    if (b_exponent != 0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                    end

                    counter <= counter + 1;
                end

                3'b010: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;

                    // Combine signs and adjust exponents
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= a_exponent + b_exponent - 127;

                    counter <= counter + 1;
                end

                3'b011: begin
                    // Round and adjust exponent
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky <= |product[21:0];

                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1;
                    end else begin
                        z_mantissa <= product[49:26];
                    end

                    if (z_exponent > 255) begin
                        // Overflow
                        z <= 32'b7f800000;
                    end else if (z_exponent < -126) begin
                        // Underflow
                        z <= 32'b00000000;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                3'b100: begin
                    // Format final result
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