module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits
reg underflow, overflow; // Underflow and overflow flags

always @(posedge clk or posedge rst) begin
    if (rst) begin
        z <= 32'b0; // Reset output
        underflow <= 1'b0;
        overflow <= 1'b0;
    end else begin
        // Extract inputs
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];

        // Check for special cases (early outs)
        if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
            // Handle NaN and infinity cases
            if ((a_exponent == 9'b11111111) && (a_mantissa!= 23'b0)) begin
                z <= 32'b1; // NaN
            end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 23'b0)) begin
                z <= 32'b1; // NaN
            end else if (a_exponent == 9'b11111111) begin
                z <= (a_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end else begin
                z <= (b_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end
        end else begin
            // Calculate new exponent and sign
            z_sign <= a_sign ^ b_sign;
            z_exponent <= a_exponent + b_exponent - 9'b10000000;

            // Check for underflow and overflow
            if (z_exponent < 9'b1) begin
                underflow <= 1'b1;
                // Denormalize
                z_mantissa <= product[48:25] >> (9'b1 - z_exponent);
                z_exponent <= 9'b0;
            end else if (z_exponent > 9'b254) begin
                overflow <= 1'b1;
                // Saturate
                z_mantissa <= 23'b11111111111111111111111;
                z_exponent <= 9'b11111111;
            end else begin
                underflow <= 1'b0;
                overflow <= 1'b0;

                // Multiply mantissas
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};

                // Rounding and normalization
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];

                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[48:25] + 1;
                end else begin
                    z_mantissa <= product[48:25];
                end

                // Normalize mantissa
                if (z_mantissa[23] == 1'b0) begin
                    z_mantissa <= z_mantissa << 1;
                    z_exponent <= z_exponent - 1;
                end
            end

            // Format output
            z <= {z_sign, z_exponent, z_mantissa};
        end
    end
end

endmodule