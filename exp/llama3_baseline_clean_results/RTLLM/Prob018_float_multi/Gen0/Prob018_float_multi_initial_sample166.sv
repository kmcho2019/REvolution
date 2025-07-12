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
reg [47:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk) begin
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

                // Check for special cases
                if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                    // NaN
                    z_sign <= 1'b0;
                    z_exponent <= 8'hff;
                    z_mantissa <= 23'd0;
                end else if ((a_exponent == 8'hff && a_mantissa == 0) || (b_exponent == 8'hff && b_mantissa == 0)) begin
                    // Infinity
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 8'hff;
                    z_mantissa <= 23'd0;
                end else begin
                    // Normal numbers
                    counter <= 1;
                end
            end
            1: begin
                // Normalize mantissas if needed
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

                counter <= 2;
            end
            2: begin
                // Combine signs and adjust exponents
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;

                // Round result
                guard_bit <= product[23];
                round_bit <= product[22];
                sticky <= |product[21:0];

                counter <= 3;
            end
            3: begin
                // Adjust exponent and generate output
                if (z_exponent > 8'h7f) begin
                    // Overflow
                    z_sign <= z_sign;
                    z_exponent <= 8'hff;
                    z_mantissa <= 23'd0;
                end else if (z_exponent < 8'h1) begin
                    // Underflow
                    z_sign <= z_sign;
                    z_exponent <= 0;
                    z_mantissa <= 23'd0;
                end else begin
                    // Normal result
                    z_exponent <= z_exponent;
                    z_mantissa <= product[47:24] + (guard_bit & (round_bit | sticky));
                end

                // Output result
                z <= {z_sign, z_exponent, z_mantissa};

                counter <= 0;
            end
        endcase
    end
end

endmodule