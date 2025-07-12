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
            3'b000: begin // Input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                if ((a_exponent == 9'd255 && a_mantissa!= 24'd0) || 
                    (b_exponent == 9'd255 && b_mantissa!= 24'd0)) begin // NaN or infinity
                    z <= (a_sign || b_sign)? 32'h7fc00000 : 32'h7f800000; // Output NaN
                end else if ((a_exponent == 9'd255 && a_mantissa == 24'd0) || 
                             (b_exponent == 9'd255 && b_mantissa == 24'd0)) begin // Infinity
                    z_sign <= a_sign || b_sign;
                    z_exponent <= 9'd255;
                    z_mantissa <= 24'd0;
                    z <= {z_sign, z_exponent, z_mantissa};
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            3'b001: begin // Special cases handling and normalization
                if ((a_exponent == 9'd0 && a_mantissa[23] == 1'b0) || 
                    (b_exponent == 9'd0 && b_mantissa[23] == 1'b0)) begin // Subnormal
                    // Normalize
                    if (a_exponent == 9'd0 && a_mantissa[23] == 1'b0) begin
                        a_exponent <= a_exponent + 1'b1;
                        a_mantissa <= {1'b0, a_mantissa[22:0]};
                    end
                    if (b_exponent == 9'd0 && b_mantissa[23] == 1'b0) begin
                        b_exponent <= b_exponent + 1'b1;
                        b_mantissa <= {1'b0, b_mantissa[22:0]};
                    end
                end
                counter <= counter + 1'b1;
            end
            3'b010: begin // Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 9'd127;
                counter <= counter + 1'b1;
            end
            3'b011: begin // Rounding and adjustment
                {guard_bit, round_bit, sticky} <= product[49:47];
                if (round_bit || (guard_bit && sticky)) begin // Round up
                    z_mantissa <= product[46:23] + 1'b1;
                end else begin // Round down
                    z_mantissa <= product[46:23];
                end
                if (z_mantissa[23] == 1'b1) begin // Carry
                    z_exponent <= z_exponent + 1'b1;
                    z_mantissa <= {1'b0, z_mantissa[22:0]};
                end
                counter <= counter + 1'b1;
            end
            3'b100: begin // Output generation
                if (z_exponent == 9'd255) begin // Overflow
                    z <= (z_sign? 32'hfc000000 : 32'h7f800000);
                end else if (z_exponent == 9'd0) begin // Underflow
                    z <= (z_sign? 32'h80000000 : 32'h00000000);
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
            default: counter <= counter;
        endcase
    end
end

endmodule