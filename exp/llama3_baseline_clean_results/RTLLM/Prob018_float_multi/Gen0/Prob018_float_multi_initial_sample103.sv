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
            3'b000: begin // Initialization and Input Processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23] - 127;
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23] - 127;
                b_sign <= b[31];
                // Special Cases Handling
                if ((a_exponent == 8'd255 && a_mantissa != 23'd0) || (b_exponent == 8'd255 && b_mantissa != 23'd0)) begin
                    // NaN or Infinity
                    if (a_exponent == 8'd255 && a_mantissa != 23'd0) begin
                        z <= {32{1'b1}};
                    end else if (b_exponent == 8'd255 && b_mantissa != 23'd0) begin
                        z <= {32{1'b1}};
                    end else if (a_exponent == 8'd255) begin
                        z <= {a_sign, 8'd255, 23'd0};
                    end else begin
                        z <= {b_sign, 8'd255, 23'd0};
                    end
                end else if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    // Infinity
                    z_sign <= a_sign ^ b_sign;
                    z <= {z_sign, 8'd255, 23'd0};
                end else begin
                    counter <= counter + 1;
                end
            end
            3'b001: begin // Multiplication and Normalization
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent + 127;
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            3'b010: begin // Rounding and Adjustment
                // Extract guard, round, and sticky bits
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                // Rounding decision
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[48:25] + 1;
                    if (z_mantissa == 24'd0) begin
                        z_exponent <= z_exponent + 1;
                    end
                end else begin
                    z_mantissa <= product[48:25];
                end
                counter <= counter + 1;
            end
            3'b011: begin // Output Generation
                // Handle overflow and underflow
                if (z_exponent > 8'd254) begin
                    // Overflow
                    z <= {z_sign, 8'd255, 23'd0};
                end else if (z_exponent < 8'd1) begin
                    // Underflow
                    z <= {z_sign, 8'd0, 23'd0};
                end else begin
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 3'b000;
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule