module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 32'b0;
    end
    else begin
        if (counter == 0) begin
            // Input processing
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            counter <= counter + 1;
        end
        else if (counter == 1) begin
            // Special cases handling
            if ((a_exponent == 9'b11111111) && (a_mantissa != 0)) begin
                // a is NaN or infinity
                if (b_exponent == 9'b11111111 && b_mantissa != 0) begin
                    // b is NaN or infinity
                    if (a_mantissa != 0 && b_mantissa != 0) begin
                        // Both NaN, result is NaN
                        z <= {1'b1, 8'b11111111, 23'b0};
                    end
                    else if (a_mantissa != 0) begin
                        // a is NaN, result is NaN
                        z <= {1'b1, 8'b11111111, 23'b0};
                    end
                    else if (b_mantissa != 0) begin
                        // b is NaN, result is NaN
                        z <= {1'b1, 8'b11111111, 23'b0};
                    end
                    else begin
                        // Both infinity, result is infinity
                        z <= {a_sign, 8'b11111111, 23'b0};
                    end
                end
                else begin
                    // a is NaN or infinity, result is NaN or infinity
                    z <= {a_sign, 8'b11111111, 23'b0};
                end
            end
            else if (b_exponent == 9'b11111111 && b_mantissa != 0) begin
                // b is NaN or infinity, result is NaN or infinity
                z <= {b_sign, 8'b11111111, 23'b0};
            end
            else begin
                // Normalization
                if (a_exponent == 0 && a_mantissa != 0) begin
                    // a is subnormal
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= 1;
                end
                if (b_exponent == 0 && b_mantissa != 0) begin
                    // b is subnormal
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= 1;
                end
                counter <= counter + 1;
            end
        end
        else if (counter == 2) begin
            // Multiplication
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_exponent <= a_exponent + b_exponent - 127;
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1;
        end
        else if (counter == 3) begin
            // Rounding and adjustment
            guard_bit <= product[1];
            round_bit <= product[2];
            sticky <= |product[2:0];
            if (z_exponent > 127) begin
                // Overflow
                z_exponent <= 8'b11111111;
                z_mantissa <= 0;
            end
            else if (z_exponent < -126) begin
                // Underflow
                z_exponent <= 0;
                z_mantissa <= 0;
            end
            else begin
                z_mantissa <= product[49:26];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                    if (z_mantissa == 24'b1000000000000000000000000) begin
                        z_mantissa <= 0;
                        z_exponent <= z_exponent + 1;
                    end
                end
            end
            counter <= counter + 1;
        end
        else if (counter == 4) begin
            // Output generation
            z <= {z_sign, z_exponent, z_mantissa};
            counter <= 0;
        end
    end
end

endmodule