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

always @ (posedge clk) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin // Input Processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            1: begin // Special Cases Handling
                if ((a_exponent == 255 && a_mantissa != 0) || (b_exponent == 255 && b_mantissa != 0)) begin
                    // NaN or infinity
                    if (a_exponent == 255 && a_mantissa != 0) begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // NaN
                    end else if (b_exponent == 255 && b_mantissa != 0) begin
                        z <= {b_sign, 8'b11111111, 23'b0}; // NaN
                    end else begin
                        z <= {a_sign, 8'b11111111, 23'b0}; // Infinity
                    end
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // Normalization
                if (a_exponent == 0) begin
                    // Denormalized number
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= a_exponent - 1;
                end
                if (b_exponent == 0) begin
                    // Denormalized number
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            4: begin // Rounding and Adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= product[47:0] != 0;
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                if (z_exponent > 255) begin
                    // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0}; // Infinity
                end else if (z_exponent < -126) begin
                    // Underflow
                    z <= {z_sign, 8'b0, 23'b0}; // Zero
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule