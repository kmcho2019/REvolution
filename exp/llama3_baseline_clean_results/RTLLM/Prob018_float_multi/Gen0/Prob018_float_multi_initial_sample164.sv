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

// IEEE 754 special values
reg a_is_nan, b_is_nan, a_is_inf, b_is_inf;

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        a_is_nan <= 1'b0;
        b_is_nan <= 1'b0;
        a_is_inf <= 1'b0;
        b_is_inf <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];

                // Check for special values
                a_is_nan <= (a_exponent == 9'b11111111 && a_mantissa!= 24'b0);
                b_is_nan <= (b_exponent == 9'b11111111 && b_mantissa!= 24'b0);
                a_is_inf <= (a_exponent == 9'b11111111 && a_mantissa == 24'b0);
                b_is_inf <= (b_exponent == 9'b11111111 && b_mantissa == 24'b0);

                counter <= counter + 1;
            end
            3'b001: begin
                // Handle special cases
                if (a_is_nan || b_is_nan) begin
                    z <= 32'b0; // NaN
                end else if (a_is_inf && b_is_inf) begin
                    z <= 32'b0; // Inf * Inf = NaN
                end else if (a_is_inf) begin
                    z <= (b_sign)? 32'b0 : 32'h7f800000; // Inf * x = Inf
                end else if (b_is_inf) begin
                    z <= (a_sign)? 32'b0 : 32'h7f800000; // x * Inf = Inf
                end else begin
                    // Normalize mantissas
                    if (a_exponent == 0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= 9'b1;
                    end
                    if (b_exponent == 0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= 9'b1;
                    end

                    // Multiply mantissas and adjust exponents
                    product <= a_mantissa * b_mantissa;
                    z_exponent <= a_exponent + b_exponent - 9'b127;
                    z_sign <= a_sign ^ b_sign;

                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Round the result and adjust the exponent
                guard_bit <= product[47];
                round_bit <= product[46];
                sticky <= |product[45:0];

                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                    z_exponent <= z_exponent;
                end else begin
                    z_mantissa <= product[49:26];
                    z_exponent <= z_exponent;
                end

                // Check for overflow and underflow
                if (z_exponent > 9'b254) begin
                    z <= (z_sign)? 32'b0 : 32'h7f800000; // Overflow
                end else if (z_exponent < 9'b1) begin
                    z <= 32'b0; // Underflow
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end

                counter <= 3'b000;
            end
            default: begin
                counter <= counter;
            end
        endcase
    end
end

endmodule