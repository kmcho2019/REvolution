module float_multi(
    input         clk,
    input         rst,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers (biased)
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter
        z <= 32'b0; // Reset output
    end else begin
        case (counter)
            3'b000: begin // Initialization and input processing
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Special cases (NaN or infinity)
                    z_sign <= a_sign ^ b_sign;
                    if ((a_exponent == 9'b111111111) && (b_exponent == 9'b111111111)) begin
                        // Both NaN, result is NaN
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                    end else if (a_exponent == 9'b111111111) begin
                        // a is NaN, result is NaN
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                    end else if (b_exponent == 9'b111111111) begin
                        // b is NaN, result is NaN
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                    end else begin
                        // Infinity times finite number
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                    end
                    counter <= 3'b110; // Go to output generation
                end else if ((a_exponent == 9'b000000000) || (b_exponent == 9'b000000000)) begin
                    // Zero or subnormal
                    z_exponent <= 9'b000000000;
                    z_mantissa <= 24'b0;
                    counter <= 3'b110; // Go to output generation
                end else begin
                    counter <= 3'b001; // Proceed to normalization and multiplication
                end
            end
            3'b001: begin // Normalization and multiplication
                // Normalize mantissas if necessary
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1'b1;
                end
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;
                // Combine signs
                z_sign <= a_sign ^ b_sign;
                // Adjust exponents
                z_exponent <= a_exponent + b_exponent - 127; // Unbiased exponents
                counter <= 3'b010; // Proceed to rounding and adjustment
            end
            3'b010: begin // Rounding and adjustment
                // Round product to 23 bits
                z_mantissa <= product[49:26];
                guard_bit <= product[25];
                round_bit <= product[24];
                sticky <= |product[23:0];
                // Check for overflow
                if (z_exponent > 255) begin
                    z_exponent <= 255; // Overflow, set to infinity
                    z_mantissa <= 24'b0;
                end
                counter <= 3'b011; // Proceed to output formatting
            end
            3'b011: begin // Output formatting
                // Apply rounding
                if ((guard_bit == 1'b1) && ((round_bit == 1'b1) || sticky == 1'b1)) begin
                    z_mantissa <= z_mantissa + 1'b1;
                    if (z_mantissa == 24'b1000000000000000000000000) begin
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= 24'b0;
                    end
                end
                // Format output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b110; // Output generated
            end
            3'b110: begin // Output generated, wait for next operation
                if (a_exponent == 9'b111111111 || b_exponent == 9'b111111111) begin
                    // NaN or infinity, no need to wait
                end else begin
                    counter <= 3'b000; // Reset for next operation
                end
            end
        endcase
    end
end

endmodule