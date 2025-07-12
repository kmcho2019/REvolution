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
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization and Input Extraction
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                if ((a_exponent == 9'b111111111) && (a_mantissa != 0)) begin // NaN or Infinity
                    z <= a;
                end else if ((b_exponent == 9'b111111111) && (b_mantissa != 0)) begin
                    z <= b;
                end
                counter <= counter + 1;
            end
            3'b001: begin // Special Cases Handling
                if ((a_exponent == 9'b000000000) && (a_mantissa == 0)) begin // Zero
                    z <= {a_sign, 8'b0, 23'b0};
                end else if ((b_exponent == 9'b000000000) && (b_mantissa == 0)) begin
                    z <= {b_sign, 8'b0, 23'b0};
                end
                counter <= counter + 1;
            end
            3'b010: begin // Normalization and Multiplication
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b011: begin // Rounding and Adjustment
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                if (z_mantissa[23]) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1;
                end
                counter <= counter + 1;
            end
            3'b100: begin // Output Generation
                if (z_exponent > 255) begin // Overflow
                    z <= {z_sign, 8'b11111111, 23'b0};
                end else if (z_exponent < -126) begin // Underflow
                    z <= {z_sign, 8'b00000000, 23'b0};
                end else begin
                    z <= {z_sign, z_exponent, z_mantissa};
                end
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule