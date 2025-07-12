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

always @(*) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 9'b0;
        b_exponent <= 9'b0;
        z_exponent <= 9'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else if (clk == 1'b1) begin
        case (counter)
            3'b000: begin // Input Processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    if ((a_exponent == 9'b111111111) && (a_mantissa!= 24'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 9'b111111111) && (b_mantissa!= 24'b0)) begin
                        z <= 32'b1; // NaN
                    end else begin
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                        z_sign <= a_sign ^ b_sign;
                    end
                end else begin
                    counter <= 3'b001;
                end
            end
            3'b001: begin // Normalization and Multiplication
                // Normalize mantissas if necessary
                if (a_exponent == 9'b0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= 9'b1;
                end
                if (b_exponent == 9'b0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= 9'b1;
                end
                // Multiply mantissas
                product <= {a_mantissa, 24'b0} * {b_mantissa, 24'b0};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b010;
            end
            3'b010: begin // Rounding and Adjustment
                // Calculate guard bit, round bit, and sticky
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[1:0];
                // Round the result
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1'b1;
                    z_exponent <= z_exponent + 1'b1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                // Check for overflow and underflow
                if (z_exponent > 9'b111111110) begin
                    z_exponent <= 9'b111111111;
                    z_mantissa <= 24'b0;
                end else if (z_exponent < 9'b1) begin
                    z_exponent <= 9'b0;
                end
                counter <= 3'b011;
            end
            3'b011: begin // Output Generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule