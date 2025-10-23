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

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            1: begin
                // Special Cases Handling
                if ((a_exponent == 9'b11111111 && a_mantissa != 0) || (b_exponent == 9'b11111111 && b_mantissa != 0)) begin
                    // NaN or Infinity
                    z <= {32{1'b1}};
                end else if ((a_exponent == 9'b00000000 && a_mantissa == 0) || (b_exponent == 9'b00000000 && b_mantissa == 0)) begin
                    // Zero
                    z <= 0;
                end else begin
                    // Normalization
                    if (a_exponent == 9'b00000000) begin
                        // Denormalized
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= 9'b00000001;
                    end
                    if (b_exponent == 9'b00000000) begin
                        // Denormalized
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= 9'b00000001;
                    end
                    counter <= counter + 1;
                end
            end
            2: begin
                // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 9'b10000001;
                counter <= counter + 1;
            end
            3: begin
                // Rounding and Adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    product <= product + 1;
                end
                z_mantissa <= product[48:25];
                if (product[49]) begin
                    // Overflow
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= counter + 1;
            end
            4: begin
                // Output Generation
                if (z_exponent > 9'b11111110) begin
                    // Overflow
                    z <= {32{1'b1}};
                end else if (z_exponent < 9'b00000001) begin
                    // Underflow
                    z <= 0;
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule