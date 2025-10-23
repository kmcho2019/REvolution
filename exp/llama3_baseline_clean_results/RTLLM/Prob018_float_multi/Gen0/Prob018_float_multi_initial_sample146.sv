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
        z <= 32'b0;
    end else begin
        case (counter)
            0: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Special cases handling
                if ((a_exponent == 9'b11111111) && (a_mantissa != 0) || (b_exponent == 9'b11111111) && (b_mantissa != 0)) begin
                    // NaN
                    z <= 32'b1;
                end else if ((a_exponent == 9'b11111111) && (a_mantissa == 0) || (b_exponent == 9'b11111111) && (b_mantissa == 0)) begin
                    // Infinity
                    z <= 32'b1;
                end else begin
                    // Normalization
                    if (a_exponent == 0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= -126;
                    end
                    if (b_exponent == 0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= -126;
                    end

                    counter <= 1;
                end
            end
            1: begin
                // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;

                // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[3:0];

                if (product[50]) begin
                    // Overflow
                    z_exponent <= z_exponent + 1;
                end

                counter <= 2;
            end
            2: begin
                // Output generation
                if (z_exponent > 255) begin
                    // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else if (z_exponent < -126) begin
                    // Underflow
                    z <= {z_sign, 8'b0, 23'b0};
                end else begin
                    z_mantissa <= product[49:26];
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= z_mantissa + 1;
                    end
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end

                counter <= 0;
            end
        endcase
    end
end

endmodule