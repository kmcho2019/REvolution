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

// Reset and clock synchronization
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Input processing
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 1;
            end
            1: begin
                // Special cases handling
                if ((a_exponent == 9'hFF && a_mantissa != 0) || (b_exponent == 9'hFF && b_mantissa != 0)) begin
                    // NaN or infinity
                    z_sign <= 1'b0;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 23'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 0;
                end else if ((a_exponent == 9'hFF && a_mantissa == 0) || (b_exponent == 9'hFF && b_mantissa == 0)) begin
                    // Infinity
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 23'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 0;
                end else begin
                    counter <= 2;
                end
            end
            2: begin
                // Normalization
                if (a_exponent != 0) begin
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_exponent != 0) begin
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1;
                end
                counter <= 3;
            end
            3: begin
                // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= 4;
            end
            4: begin
                // Rounding and adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= product[46:0] != 0;
                if (guard_bit && (round_bit || sticky)) begin
                    product <= product + 1;
                end
                z_mantissa <= product[46:23];
                counter <= 5;
            end
            5: begin
                // Output generation
                if (z_exponent > 255) begin
                    // Overflow
                    z_sign <= z_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 23'd0;
                end else if (z_exponent < 1) begin
                    // Underflow
                    z_sign <= z_sign;
                    z_exponent <= 0;
                    z_mantissa <= 23'd0;
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 0;
            end
            default: counter <= 0;
        endcase
    end
end

endmodule