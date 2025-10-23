module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents (including bias)
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product
reg guard_bit, round_bit, sticky; // Rounding control bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the module
        counter <= 3'd0;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        z_mantissa <= 24'd0;
        a_exponent <= 9'd0;
        b_exponent <= 9'd0;
        z_exponent <= 9'd0;
        a_sign <= 1'd0;
        b_sign <= 1'd0;
        z_sign <= 1'd0;
        product <= 50'd0;
        guard_bit <= 1'd0;
        round_bit <= 1'd0;
        sticky <= 1'd0;
        z <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23] - 127; // Bias = 127
                b_exponent <= b[30:23] - 127; // Bias = 127
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'd1: begin
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 9'd255) && (a_mantissa!= 24'd0)) begin
                    // a is NaN, set output to NaN
                    z <= {32{1'b1}};
                end else if ((b_exponent == 9'd255) && (b_mantissa!= 24'd0)) begin
                    // b is NaN, set output to NaN
                    z <= {32{1'b1}};
                end else if ((a_exponent == 9'd255) && (a_mantissa == 24'd0) && (b_exponent == 9'd255) && (b_mantissa == 24'd0)) begin
                    // Both are infinity, set output to infinity
                    z <= {a_sign, 8'd255, 23'd0};
                end else begin
                    // Normalize mantissas if needed
                    if (a_exponent < 0) begin
                        a_mantissa <= a_mantissa >> -a_exponent;
                    end
                    if (b_exponent < 0) begin
                        b_mantissa <= b_mantissa >> -b_exponent;
                    end
                    counter <= counter + 1;
                end
            end
            3'd2: begin
                // Multiply mantissas
                product <= {1'd1, a_mantissa} * {1'd1, b_mantissa};
                // Combine signs
                z_sign <= a_sign ^ b_sign;
                // Adjust exponents
                z_exponent <= a_exponent + b_exponent;
                counter <= counter + 1;
            end
            3'd3: begin
                // Round the result
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= product[3] | product[4] | product[5] | product[6] | product[7] | product[8] | product[9] | product[10] | product[11] | product[12] | product[13] | product[14] | product[15] | product[16] | product[17] | product[18] | product[19] | product[20] | product[21] | product[22] | product[23] | product[24] | product[25] | product[26] | product[27] | product[28] | product[29] | product[30] | product[31] | product[32] | product[33] | product[34] | product[35] | product[36] | product[37] | product[38] | product[39] | product[40] | product[41] | product[42] | product[43] | product[44] | product[45] | product[46] | product[47] | product[48] | product[49];
                if ((guard_bit == 1'd1) && ((round_bit == 1'd1) || (sticky == 1'd1))) begin
                    z_mantissa <= product[49:26] + 1'd1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                // Adjust exponent
                if (z_mantissa[23] == 1'd1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'd1;
                end
                counter <= counter + 1;
            end
            3'd4: begin
                // Format the output
                if (z_exponent > 254) begin
                    // Overflow, set output to infinity
                    z <= {z_sign, 8'd255, 23'd0};
                end else if (z_exponent < -126) begin
                    // Underflow, set output to zero
                    z <= {z_sign, 8'd0, 23'd0};
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa};
                end
                counter <= 3'd0;
            end
        endcase
    end
end

endmodule