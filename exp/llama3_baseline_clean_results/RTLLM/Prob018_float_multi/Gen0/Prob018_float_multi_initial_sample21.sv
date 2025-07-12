module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [9:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'h0;
    end else begin
        case (counter)
            3'b000: begin
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
            3'b001: begin
                // Special Cases Handling
                if ((a_exponent == 10'b1111111111) && (a_mantissa != 0)) begin
                    // a is NaN
                    z <= 32'h7fc00000; // NaN
                end else if ((b_exponent == 10'b1111111111) && (b_mantissa != 0)) begin
                    // b is NaN
                    z <= 32'h7fc00000; // NaN
                end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 0) && (b_exponent == 10'b1111111111) && (b_mantissa == 0)) begin
                    // both a and b are infinity
                    z <= (a_sign == b_sign) ? 32'h7f800000 : 32'hff800000;
                end else if ((a_exponent == 10'b1111111111) && (a_mantissa == 0)) begin
                    // a is infinity
                    z <= (a_sign == b_sign) ? 32'h7f800000 : 32'hff800000;
                end else if ((b_exponent == 10'b1111111111) && (b_mantissa == 0)) begin
                    // b is infinity
                    z <= (a_sign == b_sign) ? 32'h7f800000 : 32'hff800000;
                end else begin
                    // Normalization
                    if (a_mantissa[23] == 0) begin
                        // a is denormalized
                        a_mantissa <= {1'b1, a_mantissa};
                        a_exponent <= a_exponent - 1;
                    end
                    if (b_mantissa[23] == 0) begin
                        // b is denormalized
                        b_mantissa <= {1'b1, b_mantissa};
                        b_exponent <= b_exponent - 1;
                    end
                    counter <= counter + 1;
                end
            end
            3'b010: begin
                // Multiplication
                product <= (a_mantissa * b_mantissa);
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= counter + 1;
            end
            3'b011: begin
                // Rounding and Adjustment
                if (product[49]) begin
                    // product is larger than 24 bits
                    product <= product >> 1;
                    z_exponent <= z_exponent + 1;
                end
                if (product[23] == 1) begin
                    // product is larger than 23 bits
                    product <= product >> 1;
                    z_exponent <= z_exponent + 1;
                end
                guard_bit <= product[22];
                round_bit <= product[21];
                sticky <= product[20] | product[19] | product[18] | product[17] | product[16] | product[15] | product[14] | product[13] | product[12] | product[11] | product[10] | product[9] | product[8] | product[7] | product[6] | product[5] | product[4] | product[3] | product[2] | product[1] | product[0];
                if ((guard_bit == 1) && (round_bit == 1 || sticky == 1)) begin
                    // round up
                    product <= product + 1;
                    if (product[24] == 1) begin
                        // overflow
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end
                end
                z_mantissa <= product[23:0];
                counter <= counter + 1;
            end
            3'b100: begin
                // Output Generation
                if (z_exponent > 254) begin
                    // overflow
                    z <= (z_sign == 1) ? 32'hff800000 : 32'h7f800000;
                end else if (z_exponent < -126) begin
                    // underflow
                    z <= (z_sign == 1) ? 32'hbf800000 : 32'h3f800000;
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule