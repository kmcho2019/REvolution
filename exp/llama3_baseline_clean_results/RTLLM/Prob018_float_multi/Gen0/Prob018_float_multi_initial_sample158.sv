module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponent is 8 bits for single precision
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            // Initialize
            3'b000: begin
                counter <= counter + 1;
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Check for NaN and infinity
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // Handle NaN and infinity cases
                    if (a_exponent == 9'b11111111) begin
                        z <= a; // NaN propagation
                    end else if (b_exponent == 9'b11111111) begin
                        z <= b; // NaN propagation
                    end
                end
            end
            
            // Normalize mantissas if necessary
            3'b001: begin
                counter <= counter + 1;
                // Mantissa normalization (simplified, real implementation requires checking for denormal numbers)
                a_mantissa <= a_mantissa;
                b_mantissa <= b_mantissa;
            end
            
            // Multiply mantissas and adjust exponents
            3'b010: begin
                counter <= counter + 1;
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127; // Bias adjustment for single precision
                z_sign <= a_sign ^ b_sign;
            end
            
            // Round and adjust exponent
            3'b011: begin
                counter <= counter + 1;
                // Rounding logic (simplified)
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                if (product[47]) begin
                    z_exponent <= z_exponent + 1;
                end
            end
            
            // Generate output
            3'b100: begin
                counter <= 3'b000; // Reset counter
                z <= {z_sign, z_exponent, z_mantissa};
            end
            
            default: begin
                counter <= counter + 1;
            end
        endcase
    end
end

endmodule