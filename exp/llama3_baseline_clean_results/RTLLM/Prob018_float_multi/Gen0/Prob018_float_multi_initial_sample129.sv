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
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Handle special cases
                if ((a_exponent == 255) && (a_mantissa!= 0) ||
                    (b_exponent == 255) && (b_mantissa!= 0)) begin
                    // NaN or infinity
                    z <= (a_exponent == 255)? a : b;
                end else if ((a_exponent == 255) && (a_mantissa == 0) ||
                             (b_exponent == 255) && (b_mantissa == 0)) begin
                    // Infinity
                    z <= (a_exponent == 255)? a : b;
                end else begin
                    counter <= counter + 1;
                end
            end
            1: begin
                // Normalize mantissas
                if (a_exponent!= 0) begin
                    a_mantissa <= a_mantissa << (a_exponent - 1);
                end
                if (b_exponent!= 0) begin
                    b_mantissa <= b_mantissa << (b_exponent - 1);
                end
                // Multiply mantissas
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                counter <= counter + 1;
            end
            2: begin
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                // Round and adjust exponent
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= product[3] || product[4] || product[5] || product[6] || product[7] || product[8] || product[9] || product[10] || product[11] || product[12] || product[13] || product[14] || product[15] || product[16] || product[17] || product[18] || product[19] || product[20] || product[21] || product[22] || product[23] || product[24] || product[25] || product[26] || product[27] || product[28] || product[29] || product[30] || product[31] || product[32] || product[33] || product[34] || product[35] || product[36] || product[37] || product[38] || product[39] || product[40] || product[41] || product[42] || product[43] || product[44] || product[45] || product[46] || product[47] || product[48];
                counter <= counter + 1;
            end
            3: begin
                // Format final result
                if (z_exponent >= 255) begin
                    // Overflow
                    z <= (z_sign)? 32'h80000000 : 32'h7f800000;
                end else if (z_exponent <= 0) begin
                    // Underflow
                    z <= (z_sign)? 32'h80000000 : 32'h00000000;
                end else begin
                    z_mantissa <= product[48:25];
                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= z_mantissa + 1;
                    end
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule