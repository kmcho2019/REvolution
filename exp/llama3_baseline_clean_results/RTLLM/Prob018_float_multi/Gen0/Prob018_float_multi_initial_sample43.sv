module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end
    else begin
        case (counter)
            0: begin // Input processing and special cases handling
                a_sign <= a[31];
                b_sign <= b[31];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_mantissa <= {1'b1, a[22:0]};
                b_mantissa <= {1'b1, b[22:0]};
                if (a_exponent == 8'b11111111) begin // NaN or infinity
                    if (a_mantissa != 0) begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // NaN
                    end
                    else begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // infinity
                    end
                end
                else if (b_exponent == 8'b11111111) begin // NaN or infinity
                    if (b_mantissa != 0) begin
                        z <= {b_sign, 8'b11111111, 23'b0}; // NaN
                    end
                    else begin
                        z <= {b_sign, 8'b11111111, 23'b0}; // infinity
                    end
                end
                counter <= counter + 1;
            end
            1: begin // Normalization and multiplication
                if (a_exponent != 0) begin
                    // Normalize a
                    while (a_mantissa[23] == 0) begin
                        a_mantissa <= a_mantissa << 1;
                        a_exponent <= a_exponent - 1;
                    end
                end
                if (b_exponent != 0) begin
                    // Normalize b
                    while (b_mantissa[23] == 0) begin
                        b_mantissa <= b_mantissa << 1;
                        b_exponent <= b_exponent - 1;
                    end
                end
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127; // Subtract bias
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            2: begin // Rounding and adjustment
                // Rounding
                guard_bit <= product[24];
                round_bit <= product[25];
                sticky <= |product[26:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[23:0] + 1;
                end
                else begin
                    z_mantissa <= product[23:0];
                end
                // Adjust exponent
                if (z_mantissa[23] == 1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3: begin // Output generation
                if (z_exponent > 255) begin
                    z <= {z_sign, 8'b11111111, 23'b0}; // Overflow
                end
                else if (z_exponent < 1) begin
                    z <= {z_sign, 8'b00000000, 23'b0}; // Underflow
                end
                else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule