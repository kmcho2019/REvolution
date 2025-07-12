module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'd0;
        end else begin
            case (counter)
                3'b000: begin // Cycle 1: Input extraction and special case handling
                    // Extract mantissas, exponents, and sign bits
                    a_mantissa <= {a[22], a[21:0]};
                    b_mantissa <= {b[22], b[21:0]};
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Handle special cases
                    if ((a_exponent == 10'd255 && a_mantissa != 24'd0) || (b_exponent == 10'd255 && b_mantissa != 24'd0)) begin
                        // Handle NaN or infinity
                        z <= 32'd0;
                    end else if ((a_exponent == 10'd0 && a_mantissa == 24'd0) || (b_exponent == 10'd0 && b_mantissa == 24'd0)) begin
                        // Handle zero
                        z <= 32'd0;
                    end else begin
                        counter <= counter + 1;
                    end
                end

                3'b001: begin // Cycle 2: Normalization, mantissa multiplication, and exponent adjustment
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 1'b0) begin
                        a_mantissa <= {1'b1, a_mantissa[22:0]};
                        a_exponent <= a_exponent - 10'd1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        b_mantissa <= {1'b1, b_mantissa[22:0]};
                        b_exponent <= b_exponent - 10'd1;
                    end

                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa;

                    // Combine signs
                    z_sign <= a_sign ^ b_sign;

                    // Adjust exponents
                    z_exponent <= a_exponent + b_exponent - 10'd127;

                    counter <= counter + 1;
                end

                3'b010: begin // Cycle 3: Rounding, final adjustment, and output generation
                    // Round the result
                    guard_bit <= product[1];
                    round_bit <= product[0];
                    sticky <= |product[49:2];

                    if (guard_bit && (round_bit || sticky)) begin
                        z_mantissa <= product[49:26] + 1;
                    end else begin
                        z_mantissa <= product[49:26];
                    end

                    // Adjust exponent for overflow/underflow
                    if (z_exponent > 10'd254) begin
                        // Handle overflow
                        z <= {1'b0, 10'd255, 24'd0};
                    end else if (z_exponent < 10'd1) begin
                        // Handle underflow
                        z <= {z_sign, 10'd0, 24'd0};
                    end else begin
                        // Format final result in IEEE 754 standard
                        z <= {z_sign, z_exponent, z_mantissa[23:0]};
                    end

                    counter <= 3'b000;
                end
            endcase
        end
    end
endmodule