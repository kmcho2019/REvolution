module float_multi (
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
        z <= 32'h00000000;
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
                counter <= 1;
            end
            1: begin
                // Special Cases Handling
                if (a_exponent == 9'hFF && a_mantissa != 0) begin
                    // a is NaN
                    z <= 32'h7FC00000; // Result is NaN
                end else if (b_exponent == 9'hFF && b_mantissa != 0) begin
                    // b is NaN
                    z <= 32'h7FC00000; // Result is NaN
                end else if (a_exponent == 9'hFF && a_mantissa == 0) begin
                    // a is infinity
                    if (b_exponent == 9'hFF && b_mantissa == 0) begin
                        // b is infinity
                        if (a_sign == b_sign) begin
                            // Result is infinity
                            z <= {a_sign, 8'hFF, 23'h000000};
                        end else begin
                            // Result is NaN
                            z <= 32'h7FC00000;
                        end
                    end else begin
                        // Result is infinity
                        z <= {a_sign, 8'hFF, 23'h000000};
                    end
                end else if (b_exponent == 9'hFF && b_mantissa == 0) begin
                    // b is infinity
                    // Result is infinity
                    z <= {b_sign, 8'hFF, 23'h000000};
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
                    counter <= 2;
                end
            end
            2: begin
                // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3;
            end
            3: begin
                // Rounding and Adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    product <= product + 1;
                end
                z_mantissa <= product[47:24];
                if (product[48]) begin
                    z_exponent <= z_exponent + 1;
                end
                counter <= 4;
            end
            4: begin
                // Output Generation
                if (z_exponent > 255) begin
                    // Overflow
                    z <= {z_sign, 8'hFF, 23'h000000};
                end else if (z_exponent < 1) begin
                    // Underflow
                    z <= {z_sign, 8'h00, 23'h000000};
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 0;
            end
        endcase
    end
end

endmodule