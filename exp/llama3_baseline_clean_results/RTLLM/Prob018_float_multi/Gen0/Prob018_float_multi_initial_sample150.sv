module float_multi (
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 32'd0;
    end else begin
        case (counter)
            0: begin // Initialization
                a_mantissa <= {a[22:0], 1'b1}; // Assuming the hidden bit is 1
                b_mantissa <= {b[22:0], 1'b1};
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= counter + 1;
            end
            1: begin // Special Cases Handling
                if ((a_exponent == 10'd255 && a_mantissa != 24'd0) || (b_exponent == 10'd255 && b_mantissa != 24'd0)) begin
                    // NaN or Infinity
                    z <= {a_sign || b_sign, 10'd255, 23'd0};
                end else if (a_exponent == 10'd0 || b_exponent == 10'd0) begin
                    // Zero or Subnormal
                    if (a_exponent == 10'd0) begin
                        if (b_exponent == 10'd0) begin
                            z <= {a_sign ^ b_sign, 10'd0, 23'd0};
                        end else begin
                            z <= {a_sign ^ b_sign, 10'd0, b_mantissa};
                        end
                    end else begin
                        z <= {a_sign ^ b_sign, 10'd0, a_mantissa};
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // Normalization
                // Ensure the mantissas are normalized
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1;
                end
                counter <= counter + 1;
            end
            3: begin // Multiplication
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 10'd127; // Bias adjustment
                z_sign <= a_sign ^ b_sign;
                counter <= counter + 1;
            end
            4: begin // Rounding and Adjustment
                // Extract guard bit, round bit, and sticky bit
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                // Perform rounding
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                // Adjust exponent if necessary
                if (z_mantissa[23] == 1'b0) begin
                    z_mantissa <= {1'b1, z_mantissa[22:0]};
                    z_exponent <= z_exponent - 1;
                end
                counter <= counter + 1;
            end
            5: begin // Output Generation
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter <= 0;
            end
            default: begin
                counter <= 0;
            end
        endcase
    end
end

endmodule