module float_multi(clk, rst, a, b, z);
    input clk;
    input rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // Initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'h0;
        end else if (counter == 3'b000) begin
            // Extract mantissas, exponents, and sign bits
            a_mantissa <= a[22:0];
            a_exponent <= a[30:23];
            a_sign <= a[31];

            b_mantissa <= b[22:0];
            b_exponent <= b[30:23];
            b_sign <= b[31];

            counter <= counter + 1;
        end else if (counter == 3'b001) begin
            // Special cases handling and normalization
            if ((a_exponent == 8'b11111111 && a_mantissa != 0) || (b_exponent == 8'b11111111 && b_mantissa != 0)) begin
                // NaN or infinity
                z <= {a_sign, 8'b11111111, 23'b0};
            end else if (a_exponent == 0 && b_exponent == 0) begin
                // Underflow
                z <= {a_sign ^ b_sign, 8'b00000000, 23'b0};
            end else begin
                // Normalize mantissas
                if (a_exponent == 0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= 1;
                end
                if (b_exponent == 0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= 1;
                end

                counter <= counter + 1;
            end
        end else if (counter == 3'b010) begin
            // Multiplication and rounding
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 127;

            // Rounding
            guard_bit <= product[48];
            round_bit <= product[47];
            sticky <= |product[46:0];

            if (guard_bit && (round_bit || sticky)) begin
                product <= product + 1;
            end

            counter <= counter + 1;
        end else if (counter == 3'b011) begin
            // Final result formatting
            if (product[49]) begin
                // Overflow
                z <= {z_sign, 8'b11111111, 23'b0};
            end else begin
                z_mantissa <= product[47:24];
                z_exponent <= z_exponent + 127;

                z <= {z_sign, z_exponent[7:0], z_mantissa};
            end

            counter <= 3'b000;
        end
    end
endmodule