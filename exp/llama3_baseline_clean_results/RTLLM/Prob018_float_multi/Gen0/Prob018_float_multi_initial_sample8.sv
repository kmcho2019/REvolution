module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// FSM state transitions
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter to zero on reset
        z <= 32'b0; // Reset output to zero
    end else begin
        case (counter)
            3'b000: begin // Input Processing
                // Extract mantissas, exponents, and sign bits
                a_sign <= a[31];
                a_exponent <= a[30:23];
                a_mantissa <= {1'b1, a[22:0]};
                
                b_sign <= b[31];
                b_exponent <= b[30:23];
                b_mantissa <= {1'b1, b[22:0]};
                
                counter <= 3'b001;
            end
            3'b001: begin // Special Cases Handling and Normalization
                // Check for special cases (NaN, infinity) and handle them
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // Handle infinity or NaN
                    if ((a_exponent == 9'b11111111) && (b_exponent == 9'b11111111)) begin
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 9'b11111111;
                        z_mantissa <= 24'b0;
                    end else if (a_exponent == 9'b11111111) begin
                        z_sign <= a_sign;
                        z_exponent <= 9'b11111111;
                        z_mantissa <= 24'b0;
                    end else begin
                        z_sign <= b_sign;
                        z_exponent <= 9'b11111111;
                        z_mantissa <= 24'b0;
                    end
                    counter <= 3'b100;
                end else if ((a_exponent == 0) || (b_exponent == 0)) begin
                    // Handle denormalized numbers
                    // Normalize if necessary
                    if (a_exponent == 0) begin
                        // Normalize a
                        a_mantissa <= a_mantissa << 1;
                        a_exponent <= a_exponent + 1'b1;
                    end
                    if (b_exponent == 0) begin
                        // Normalize b
                        b_mantissa <= b_mantissa << 1;
                        b_exponent <= b_exponent + 1'b1;
                    end
                    counter <= 3'b010;
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Multiplication
                // Multiply the mantissas
                product <= a_mantissa * b_mantissa;
                // Combine the signs
                z_sign <= a_sign ^ b_sign;
                // Adjust the exponents
                z_exponent <= a_exponent + b_exponent - 10'b0111111111; // Subtract bias
                counter <= 3'b011;
            end
            3'b011: begin // Rounding and Adjustment
                // Round the result
                guard_bit <= product[24];
                round_bit <= product[25];
                sticky <= |product[26:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[23:0] + 1;
                    if (z_mantissa == 24'b10000000000000000000000000) begin
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= 24'b0;
                    end
                end else begin
                    z_mantissa <= product[23:0];
                end
                counter <= 3'b100;
            end
            3'b100: begin // Output Generation
                // Format the final result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter <= 3'b000; // Reset counter for next operation
            end
            default: counter <= 3'b000;
        endcase
    end
end

endmodule