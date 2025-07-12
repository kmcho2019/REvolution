module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        // Counter and state machine logic
        case (counter)
            3'b000: begin // Initialization
                // Extract mantissas, exponents, and signs
                a_mantissa <= {a[22], a[21:0]};
                b_mantissa <= {b[22], b[21:0]};
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Check for special cases (NaN, Infinity)
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Handle NaN or Infinity
                    if ((a_exponent == 9'b111111111) && (a_mantissa != 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 9'b111111111) && (b_mantissa != 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((a_exponent == 9'b111111111) && (a_sign == 1'b0)) begin
                        z <= {1'b0, 8'b11111111, 23'b0}; // +Infinity
                    end else if ((b_exponent == 9'b111111111) && (b_sign == 1'b0)) begin
                        z <= {1'b0, 8'b11111111, 23'b0}; // +Infinity
                    end else if ((a_exponent == 9'b111111111) && (a_sign == 1'b1)) begin
                        z <= {1'b1, 8'b11111111, 23'b0}; // -Infinity
                    end else if ((b_exponent == 9'b111111111) && (b_sign == 1'b1)) begin
                        z <= {1'b1, 8'b11111111, 23'b0}; // -Infinity
                    end
                    counter <= 3'b111; // Done
                end else begin
                    // Normalize mantissas if needed
                    if (a_mantissa[23] == 1'b0) begin
                        // Normalize a
                        a_mantissa <= {a_mantissa[22:0], 1'b0};
                        a_exponent <= a_exponent - 1'b1;
                    end
                    if (b_mantissa[23] == 1'b0) begin
                        // Normalize b
                        b_mantissa <= {b_mantissa[22:0], 1'b0};
                        b_exponent <= b_exponent - 1'b1;
                    end
                    counter <= 3'b001; // Next state
                end
            end
            3'b001: begin // Multiplication
                // Multiply mantissas
                product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
                // Calculate new exponent
                z_exponent <= a_exponent + b_exponent - 127;
                // Determine sign of result
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b010; // Next state
            end
            3'b010: begin // Rounding and adjustment
                // Extract guard, round, and sticky bits
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                // Round the result
                if ((round_bit == 1'b1) && ((guard_bit == 1'b1) || (sticky == 1'b1))) begin
                    z_mantissa <= product[47:24] + 1'b1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                // Check for overflow
                if (z_exponent > 255) begin
                    z <= {1'b0, 8'b11111111, 23'b0}; // +Infinity
                end else if (z_exponent < 0) begin
                    z <= {1'b0, 8'b0, 23'b0}; // Zero
                end else begin
                    // Format result in IEEE 754
                    z <= {z_sign, z_exponent[7:0], z_mantissa};
                end
                counter <= 3'b111; // Done
            end
            default: begin
                // Idle state
            end
        endcase
    end
end

endmodule