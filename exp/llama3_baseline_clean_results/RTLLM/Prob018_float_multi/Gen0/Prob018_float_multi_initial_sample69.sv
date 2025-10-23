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

always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input Processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'b001: begin
                // Special Cases Handling
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // NaN or Infinity
                    z <= (a_exponent == 9'b11111111) ? a : b;
                end else begin
                    // Normalization
                    if (a_exponent == 0) begin
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= 1;
                    end
                    if (b_exponent == 0) begin
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= 1;
                    end
                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b011: begin
                // Rounding and Adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    product[46:0] <= product[46:0] + 1;
                end
                z_mantissa <= product[46:23];
                if (product[47]) begin
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3'b100: begin
                // Output Generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule