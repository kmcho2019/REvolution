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

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end
    else begin
        case (counter)
            0: begin
                // Input processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                // Special cases handling
                if ((a_exponent == 9'hFF) || (b_exponent == 9'hFF)) begin
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 9'hFF;
                    z_mantissa <= 24'h000000;
                end
                else if ((a_exponent == 0) && (a_mantissa == 0)) begin
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 0;
                    z_mantissa <= 0;
                end
                else if ((b_exponent == 0) && (b_mantissa == 0)) begin
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= 0;
                    z_mantissa <= 0;
                end
                counter <= counter + 1;
            end
            1: begin
                // Normalization
                if (a_exponent == 0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= 1;
                end
                if (b_exponent == 0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= 1;
                end
                // Multiplication
                product <= (a_mantissa * b_mantissa);
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            2: begin
                // Rounding and adjustment
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if ((guard_bit == 1'b1) && (round_bit == 1'b1 || sticky == 1'b1)) begin
                    z_mantissa <= {1'b1, product[47:24]} + 1;
                    z_exponent <= z_exponent + 1;
                end
                else if ((guard_bit == 1'b1) && (round_bit == 1'b0 && sticky == 1'b0)) begin
                    z_mantissa <= {1'b1, product[47:24]};
                    z_exponent <= z_exponent;
                end
                else begin
                    z_mantissa <= product[47:24];
                    z_exponent <= z_exponent;
                end
                counter <= counter + 1;
            end
            3: begin
                // Output generation
                if (z_exponent > 254) begin
                    z <= {z_sign, 8'hFF, 23'h000000};
                end
                else if (z_exponent < 1) begin
                    z <= {z_sign, 8'h00, z_mantissa};
                end
                else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 0;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule