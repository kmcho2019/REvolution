module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Input processing
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                counter <= counter + 1;
            end
            3'b001: begin // Special cases handling
                if ((a_exponent == 9'b11111111) && (a_mantissa!= 0)) begin // NaN
                    z <= 32'b7fc00000;
                end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 0)) begin // NaN
                    z <= 32'b7fc00000;
                end else if ((a_exponent == 9'b11111111) && (a_mantissa == 0)) begin // Infinity
                    if (b_exponent == 9'b11111111) begin // Infinity
                        z <= (a_sign == b_sign)? 32'b7f800000 : 32'bff800000;
                    end else begin
                        z <= (a_sign)? 32'bff800000 : 32'b7f800000;
                    end
                end else if ((b_exponent == 9'b11111111) && (b_mantissa == 0)) begin // Infinity
                    if (a_exponent == 9'b11111111) begin // Infinity
                        z <= (a_sign == b_sign)? 32'b7f800000 : 32'bff800000;
                    end else begin
                        z <= (b_sign)? 32'bff800000 : 32'b7f800000;
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b010: begin // Normalization
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {a_mantissa[22:0], 1'b0};
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {b_mantissa[22:0], 1'b0};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3'b011: begin // Multiplication
                product <= {a_mantissa, 27'b0} * {b_mantissa, 27'b0};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b100: begin // Rounding and adjustment
                if (product[49] == 1'b1) begin // Rounding
                    product <= product + 1;
                end
                if (product[48] == 1'b1) begin // Overflow
                    z_exponent <= z_exponent + 1;
                    product <= product >> 1;
                end
                z_mantissa <= product[47:24];
                counter <= counter + 1;
            end
            3'b101: begin // Output generation
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule