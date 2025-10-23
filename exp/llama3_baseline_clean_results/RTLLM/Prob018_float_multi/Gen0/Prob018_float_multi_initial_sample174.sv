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
        counter <= 0;
    end else begin
        if (counter == 0) begin
            // Extract mantissas, exponents, and sign bits
            a_mantissa <= {1'b1, a[22:0]};
            b_mantissa <= {1'b1, b[22:0]};
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];

            // Special cases handling
            if ((a_exponent == 9'd255) && (a_mantissa != 0)) begin
                // a is NaN
                z <= a;
            end else if ((b_exponent == 9'd255) && (b_mantissa != 0)) begin
                // b is NaN
                z <= b;
            end else if ((a_exponent == 9'd255) && (a_mantissa == 0)) begin
                // a is infinity
                if ((b_exponent == 9'd255) && (b_mantissa == 0)) begin
                    // b is infinity
                    if (a_sign == b_sign) begin
                        // Result is infinity with same sign
                        z <= {a_sign, 8'd255, 23'd0};
                    end else begin
                        // Result is NaN
                        z <= {1'b1, 8'd255, 23'd1};
                    end
                end else begin
                    // Result is infinity with same sign as a
                    z <= {a_sign, 8'd255, 23'd0};
                end
            end else if ((b_exponent == 9'd255) && (b_mantissa == 0)) begin
                // b is infinity
                // Result is infinity with same sign as b
                z <= {b_sign, 8'd255, 23'd0};
            end else begin
                counter <= counter + 1;
            end
        end else if (counter == 1) begin
            // Normalize mantissas if necessary
            if (a_mantissa[23] == 0) begin
                a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                a_exponent <= a_exponent - 1;
            end
            if (b_mantissa[23] == 0) begin
                b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                b_exponent <= b_exponent - 1;
            end

            // Multiply mantissas
            product <= a_mantissa * b_mantissa;

            counter <= counter + 1;
        end else if (counter == 2) begin
            // Combine signs and adjust exponents
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 127;

            // Round result and adjust exponent
            guard_bit <= product[49];
            round_bit <= product[48];
            sticky <= |product[47:0];
            if ((guard_bit && (round_bit || sticky)) || (round_bit && sticky)) begin
                z_mantissa <= product[47:24] + 1;
            end else begin
                z_mantissa <= product[47:24];
            end
            if (z_mantissa[23] == 1) begin
                z_exponent <= z_exponent + 1;
                z_mantissa <= z_mantissa >> 1;
            end

            // Format result in IEEE 754 standard
            if (z_exponent > 9'd254) begin
                // Overflow
                z <= {z_sign, 8'd255, 23'd0};
            end else if (z_exponent < 1) begin
                // Underflow
                z <= {z_sign, 8'd0, 23'd0};
            end else begin
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
            end
        end
    end
end

endmodule