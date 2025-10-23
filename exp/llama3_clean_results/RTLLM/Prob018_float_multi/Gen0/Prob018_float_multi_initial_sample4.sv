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
        a_mantissa <= 0;
        b_mantissa <= 0;
        z_mantissa <= 0;
        a_exponent <= 0;
        b_exponent <= 0;
        z_exponent <= 0;
        a_sign <= 0;
        b_sign <= 0;
        z_sign <= 0;
        product <= 0;
        guard_bit <= 0;
        round_bit <= 0;
        sticky <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign; // Calculate sign of result
                // Check for NaN or infinity
                if (a_exponent == 9'hFF || b_exponent == 9'hFF) begin
                    // Handle NaN or infinity
                    if (a_exponent == 9'hFF) begin
                        z <= a;
                    end else if (b_exponent == 9'hFF) begin
                        z <= b;
                    end
                end else begin
                    // Normalize mantissas if necessary
                    if (a_exponent != 0) begin
                        // Normalize a_mantissa
                    end
                    if (b_exponent != 0) begin
                        // Normalize b_mantissa
                    end
                end
                counter <= counter + 1;
            end
            1: begin
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;
                // Adjust exponent
                z_exponent <= a_exponent + b_exponent - 127; // Bias = 127 for single precision
                // Check for overflow
                if (z_exponent > 8'h7F) begin
                    z_exponent <= 8'h7F;
                    z_mantissa <= 0;
                end
                counter <= counter + 1;
            end
            2: begin
                // Round result
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= product[46:0] != 0;
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= z_mantissa + 1;
                end
                // Check for carry
                if (z_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 0;
                end
                // Generate final output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end
        endcase
    end
end

endmodule