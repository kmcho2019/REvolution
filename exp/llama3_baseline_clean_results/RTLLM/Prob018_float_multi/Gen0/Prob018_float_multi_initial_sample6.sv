module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg guard_bit, round_bit, sticky;

    // Always block for combinational logic and sequential behavior
    always @(posedge clk) begin
        if (rst) begin
            // Reset counter and outputs on reset
            counter <= 3'b000;
            z <= 32'b0;
        end else begin
            // Increment counter for operation sequencing
            counter <= counter + 1'b1;

            case (counter)
                // Input processing stage
                3'b001: begin
                    // Extract mantissas, exponents, and sign bits from inputs
                    a_mantissa <= a[22:0];
                    b_mantissa <= b[22:0];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_sign <= a[31];
                    b_sign <= b[31];
                end

                // Special cases handling and normalization
                3'b010: begin
                    // Check for special cases (NaN, infinity)
                    if (a_exponent == 9'b111111111 || b_exponent == 9'b111111111) begin
                        // Handle special cases according to IEEE 754
                        if (a_exponent == 9'b111111111 && a_mantissa != 23'b0) begin
                            // NaN
                            z_sign <= a_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end else if (b_exponent == 9'b111111111 && b_mantissa != 23'b0) begin
                            // NaN
                            z_sign <= b_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end else if (a_exponent == 9'b111111111 && a_mantissa == 23'b0) begin
                            // Infinity
                            z_sign <= a_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end else if (b_exponent == 9'b111111111 && b_mantissa == 23'b0) begin
                            // Infinity
                            z_sign <= b_sign;
                            z_exponent <= 9'b111111111;
                            z_mantissa <= 23'b0;
                        end
                    end else begin
                        // Normalize mantissas if necessary
                        if (a_mantissa[23] == 1'b0) begin
                            // Normalize a_mantissa
                            a_mantissa <= {1'b1, a_mantissa[22:1]};
                            a_exponent <= a_exponent - 1'b1;
                        end
                        if (b_mantissa[23] == 1'b0) begin
                            // Normalize b_mantissa
                            b_mantissa <= {1'b1, b_mantissa[22:1]};
                            b_exponent <= b_exponent - 1'b1;
                        end
                    end
                end

                // Multiplication stage
                3'b011: begin
                    // Multiply mantissas and combine signs
                    product <= a_mantissa * b_mantissa;
                    z_sign <= a_sign ^ b_sign;
                    // Adjust exponents
                    z_exponent <= a_exponent + b_exponent + 1'b1;
                end

                // Rounding and adjustment stage
                3'b100: begin
                    // Round the product
                    guard_bit <= product[49];
                    round_bit <= product[48];
                    sticky <= product[47:0] != 49'b0;
                    if (guard_bit && (round_bit || sticky)) begin
                        // Round up
                        product <= product + 1;
                    end
                    // Adjust exponent
                    if (product[49:48] == 2'b11) begin
                        // Overflow, adjust exponent
                        z_exponent <= z_exponent + 1'b1;
                        product <= product >> 1;
                    end
                end

                // Output generation stage
                3'b101: begin
                    // Format output in IEEE 754 standard
                    z_mantissa <= product[47:24];
                    z_exponent <= z_exponent - 127;
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 3'b000; // Reset counter
                end
            endcase
        end
    end
endmodule