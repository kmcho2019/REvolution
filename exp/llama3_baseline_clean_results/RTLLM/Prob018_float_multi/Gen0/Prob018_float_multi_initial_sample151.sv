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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'd0;
    end else begin
        case (counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 9'd255 && a_mantissa != 0) || (b_exponent == 9'd255 && b_mantissa != 0)) begin
                    // NaN or infinity handling
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 9'd255;
                    z_mantissa <= 24'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else if ((a_exponent == 9'd0 && a_mantissa == 0) || (b_exponent == 9'd0 && b_mantissa == 0)) begin
                    // Zero handling
                    z_sign <= a_sign && b_sign;
                    z_exponent <= 9'd0;
                    z_mantissa <= 24'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin // Normalization
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin // Multiplication
                product <= a_mantissa * b_mantissa;
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 127;
                counter <= counter + 1;
            end
            3'b100: begin // Rounding and adjustment
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[2:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= {z_mantissa[22:0], 1'b0} >> 1;
                    z_exponent <= z_exponent + 1;
                end
                z <= {z_sign, z_exponent[8:0], z_mantissa};
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule