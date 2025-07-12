module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [2:0] counter; // Cycle counter
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
    reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
    reg a_sign, b_sign, z_sign; // Sign bits
    reg [49:0] product; // Intermediate product of mantissas
    reg guard_bit, round_bit, sticky; // Rounding control bits

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000; // Reset counter
            z <= 32'b0; // Reset output
        end else begin
            case (counter)
                // Input Processing
                3'b000: begin
                    a_sign <= a[31]; // Extract sign bit of a
                    a_exponent <= a[30:23]; // Extract exponent of a
                    a_mantissa <= a[22:0]; // Extract mantissa of a
                    b_sign <= b[31]; // Extract sign bit of b
                    b_exponent <= b[30:23]; // Extract exponent of b
                    b_mantissa <= b[22:0]; // Extract mantissa of b
                    counter <= counter + 1;
                end

                // Special Cases Handling and Normalization
                3'b001: begin
                    if ((a_exponent == 9'b11111111) && (a_mantissa != 23'b0)) begin
                        // NaN
                        z <= 32'b1; // Setting output to NaN (simplified)
                    end else if ((b_exponent == 9'b11111111) && (b_mantissa != 23'b0)) begin
                        // NaN
                        z <= 32'b1; // Setting output to NaN (simplified)
                    end else if ((a_exponent == 9'b11111111) && (a_mantissa == 23'b0)) begin
                        // Infinity
                        if (a_sign) begin
                            // Negative Infinity
                            z <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // Negative Infinity
                        end else begin
                            // Positive Infinity
                            z <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Positive Infinity
                        end
                    end else if ((b_exponent == 9'b11111111) && (b_mantissa == 23'b0)) begin
                        // Infinity
                        if (b_sign) begin
                            // Negative Infinity
                            z <= 32'b1000_0000_0000_0000_0000_0000_0000_0000; // Negative Infinity
                        end else begin
                            // Positive Infinity
                            z <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Positive Infinity
                        end
                    end else begin
                        // Normalize mantissas if necessary (simplified, assuming already normalized)
                        z_sign <= a_sign ^ b_sign; // Determine sign of result
                        z_exponent <= a_exponent + b_exponent - 9'b10000000; // Calculate new exponent
                        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa}; // Multiply mantissas
                        counter <= counter + 1;
                    end
                end

                // Multiplication and Rounding
                3'b010: begin
                    // Extract mantissa product parts (simplified)
                    z_mantissa <= product[48:25];
                    guard_bit <= product[24];
                    round_bit <= product[23];
                    sticky <= |product[22:0]; // Simplified sticky bit calculation

                    if (guard_bit || round_bit || sticky) begin
                        // Rounding (simplified, rounding up)
                        z_mantissa <= z_mantissa + 1;
                    end
                    counter <= counter + 1;
                end

                // Output Generation
                3'b011: begin
                    // Assemble result (simplified, not handling denormal or overflow fully)
                    z <= {z_sign, z_exponent, z_mantissa};
                    counter <= 3'b000; // Reset counter
                end

                default: begin
                    counter <= 3'b000; // Reset counter on unexpected state
                end
            endcase
        end
    end

endmodule