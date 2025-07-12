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
    if(rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case(counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                if((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin // Special cases handling (NaN or infinity)
                    z <= (a_exponent == 9'b11111111) ? a : b;
                    counter <= 3'b100;
                end else begin
                    counter <= 3'b001;
                end
            end
            3'b001: begin // Normalization and multiplication
                if(a_exponent == 0) begin
                    a_mantissa <= {1'b1, a_mantissa};
                    a_exponent <= 9'b0;
                end
                if(b_exponent == 0) begin
                    b_mantissa <= {1'b1, b_mantissa};
                    b_exponent <= 9'b0;
                end
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b010;
            end
            3'b010: begin // Rounding and adjustment
                if(product[48:46] == 3'b100) begin // Rounding up
                    z_mantissa <= product[45:23] + 1;
                end else if(product[48:46] == 3'b000) begin // No rounding
                    z_mantissa <= product[45:23];
                end else begin // Rounding down
                    z_mantissa <= product[45:23];
                end
                if(z_mantissa[23]) begin // Carry into exponent
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                if(z_exponent > 255) begin // Overflow
                    z <= (z_sign) ? 32'b0 : 32'b11111111_10000000_00000000_00000000;
                end else if(z_exponent < 1) begin // Underflow
                    z <= (z_sign) ? 32'b10000000_00000000_00000000_00000000 : 32'b0;
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                    counter <= 3'b100;
                end
            end
            3'b100: begin // Output generation
                counter <= 3'b000;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule