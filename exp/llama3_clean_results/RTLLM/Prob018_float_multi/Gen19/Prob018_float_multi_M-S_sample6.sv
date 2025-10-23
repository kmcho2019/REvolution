module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [0:0] a_sign, b_sign, z_sign;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg [22:0] a_mantissa, b_mantissa, z_mantissa;
reg [45:0] product;
reg guard, round_bit, sticky;
reg [2:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        a_sign <= 0;
        a_exponent <= 0;
        a_mantissa <= 0;
        b_sign <= 0;
        b_exponent <= 0;
        b_mantissa <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                counter <= counter + 1;
            end
            1: begin
                // Mantissa multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                counter <= counter + 1;
            end
            2: begin
                // Exponent calculation and rounding
                z_exponent <= a_exponent + b_exponent - 8'd127;
                guard <= product[45];
                round_bit <= product[44];
                sticky <= |product[43:0];
                if (guard && (round_bit || sticky)) begin
                    z_mantissa <= product[44:23] + 1;
                end else begin
                    z_mantissa <= product[44:23];
                end
                counter <= counter + 1;
            end
            3: begin
                // Result formatting
                z_sign <= a_sign ^ b_sign;
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 0;
            end
        endcase
    end
end

endmodule