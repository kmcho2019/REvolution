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

// State machine to control the operation flow
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization
                counter <= counter + 1'b1;
                a_mantissa <= {1'b1, a[22:0]};
                b_mantissa <= {1'b1, b[22:0]};
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign;
            end
            3'b001: begin // Special cases handling and normalization
                counter <= counter + 1'b1;
                if ((a_exponent == 9'b11111111 && a_mantissa != 0) || (b_exponent == 9'b11111111 && b_mantissa != 0)) begin
                    // Handling NaN or infinity
                    z <= (a_exponent == 9'b11111111 && a_mantissa != 0) ? a : b;
                end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                    // Handling zero
                    z <= 32'b0;
                end else begin
                    // Normalization and multiplication preparation
                    if (a_exponent == 0) begin
                        a_mantissa <= {1'b1, a[22:0]};
                        a_exponent <= -126;
                    end
                    if (b_exponent == 0) begin
                        b_mantissa <= {1'b1, b[22:0]};
                        b_exponent <= -126;
                    end
                end
            end
            3'b010: begin // Multiplication
                counter <= counter + 1'b1;
                product <= (a_mantissa * b_mantissa);
                z_exponent <= a_exponent + b_exponent - 127;
            end
            3'b011: begin // Rounding and adjustment
                counter <= counter + 1'b1;
                {guard_bit, round_bit, sticky} <= {product[49:47]};
                if (guard_bit || round_bit || sticky) begin
                    product[48] <= product[48] + 1'b1;
                end
                z_mantissa <= product[47:24];
                if (product[48]) begin
                    z_exponent <= z_exponent + 1'b1;
                end
            end
            3'b100: begin // Output generation
                counter <= 3'b000;
                if (z_exponent > 127) begin
                    // Overflow handling
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else if (z_exponent < -126) begin
                    // Underflow handling
                    z <= {z_sign, 8'b00000000, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent + 127, z_mantissa[22:0]};
                end
            end
            default: begin
                counter <= counter;
            end
        endcase
    end
end

endmodule