module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter; // Cycle counter
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
    reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents (including bias)
    reg a_sign, b_sign, z_sign; // Sign bits
    reg [49:0] product; // Intermediate product
    reg guard_bit, round_bit, sticky; // Rounding control bits

    // Initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
        end
        else if (counter == 3'b000) begin // First cycle: extract inputs
            a_sign <= a[31];
            a_exponent <= a[30:23];
            a_mantissa <= a[22:0];
            b_sign <= b[31];
            b_exponent <= b[30:23];
            b_mantissa <= b[22:0];
            counter <= counter + 1'b1;
        end
        else if (counter == 3'b001) begin // Second cycle: handle special cases and normalize
            if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin // NaN or infinity
                // Handle NaN or infinity
                z <= (a_exponent == 9'b11111111) ? a : b;
                counter <= 3'b000;
            end
            else if ((a_exponent == 9'b0) || (b_exponent == 9'b0)) begin // Zero or denormal
                // Handle zero or denormal
                if (a_exponent == 9'b0 && b_exponent == 9'b0) begin
                    z_exponent <= 9'b0;
                    z_mantissa <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                    z_sign <= a_sign ^ b_sign;
                end
                else if (a_exponent == 9'b0) begin
                    z_exponent <= b_exponent - 9'b1;
                    z_mantissa <= {1'b0, a_mantissa} * {1'b1, b_mantissa};
                    z_sign <= a_sign ^ b_sign;
                end
                else begin
                    z_exponent <= a_exponent - 9'b1;
                    z_mantissa <= {1'b1, a_mantissa} * {1'b0, b_mantissa};
                    z_sign <= a_sign ^ b_sign;
                end
                counter <= 3'b000;
            end
            else begin // Normal numbers
                a_exponent <= a_exponent - 9'b127; // Unbias
                b_exponent <= b_exponent - 9'b127; // Unbias
                z_exponent <= a_exponent + b_exponent + 9'b127; // Bias
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1'b1;
            end
        end
        else if (counter == 3'b010) begin // Third cycle: round and adjust
            {guard_bit, round_bit, sticky} <= product[48:46];
            if (guard_bit || round_bit || sticky) begin
                // Round up
                product <= product + 50'b1;
            end
            z_mantissa <= product[47:24];
            counter <= counter + 1'b1;
        end
        else if (counter == 3'b011) begin // Fourth cycle: finalize output
            if (z_exponent > 9'b255) begin // Overflow
                z <= {z_sign, 9'b11111111, 23'b0};
            end
            else if (z_exponent < 9'b1) begin // Underflow
                z <= {z_sign, 9'b0, 23'b0};
            end
            else begin
                z <= {z_sign, z_exponent, z_mantissa};
            end
            counter <= 3'b000;
        end
    end
endmodule