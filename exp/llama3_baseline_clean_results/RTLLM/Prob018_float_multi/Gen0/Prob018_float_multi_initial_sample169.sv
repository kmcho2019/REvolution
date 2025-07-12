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

// State machine states
enum logic [2:0] {
    IDLE,
    INPUT_PROCESSING,
    SPECIAL_CASES_HANDLING,
    NORMALIZATION,
    MULTIPLICATION,
    ROUNDING_AND_ADJUSTMENT,
    OUTPUT_GENERATION
} state, next_state;

// Initialize counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (a != 32'b0 && b != 32'b0) begin
                    state <= INPUT_PROCESSING;
                end
            end
            INPUT_PROCESSING: begin
                // Extract mantissas, exponents, and sign bits from inputs
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                state <= SPECIAL_CASES_HANDLING;
            end
            SPECIAL_CASES_HANDLING: begin
                // Check for special cases like NaN and infinity
                if (a_exponent == 9'b111111111 || b_exponent == 9'b111111111) begin
                    // Handle infinity
                    if (a_exponent == 9'b111111111 && b_exponent == 9'b111111111) begin
                        // Both inputs are infinity
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                        state <= OUTPUT_GENERATION;
                    end else if (a_exponent == 9'b111111111) begin
                        // Input a is infinity
                        z_sign <= a_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                        state <= OUTPUT_GENERATION;
                    end else begin
                        // Input b is infinity
                        z_sign <= b_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= 24'b0;
                        state <= OUTPUT_GENERATION;
                    end
                end else if (a_mantissa != 23'b0 || b_mantissa != 23'b0) begin
                    // Check for NaN
                    if (a_exponent == 9'b111111111 && a_mantissa != 23'b0) begin
                        // Input a is NaN
                        z_sign <= a_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= a_mantissa;
                        state <= OUTPUT_GENERATION;
                    end else if (b_exponent == 9'b111111111 && b_mantissa != 23'b0) begin
                        // Input b is NaN
                        z_sign <= b_sign;
                        z_exponent <= 9'b111111111;
                        z_mantissa <= b_mantissa;
                        state <= OUTPUT_GENERATION;
                    end else begin
                        state <= NORMALIZATION;
                    end
                end else begin
                    // Both inputs are zero
                    z_sign <= a_sign;
                    z_exponent <= 9'b0;
                    z_mantissa <= 24'b0;
                    state <= OUTPUT_GENERATION;
                end
            end
            NORMALIZATION: begin
                // Normalize mantissas if needed
                if (a_mantissa[22] == 1'b0) begin
                    a_mantissa <= {1'b1, a_mantissa[22:1]};
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[22] == 1'b0) begin
                    b_mantissa <= {1'b1, b_mantissa[22:1]};
                    b_exponent <= b_exponent - 1'b1;
                end
                state <= MULTIPLICATION;
            end
            MULTIPLICATION: begin
                // Multiply mantissas and adjust exponents
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent + 1'b1;
                z_sign <= a_sign ^ b_sign;
                state <= ROUNDING_AND_ADJUSTMENT;
            end
            ROUNDING_AND_ADJUSTMENT: begin
                // Round result and adjust exponent
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1'b1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_mantissa <= z_mantissa >> 1;
                    z_exponent <= z_exponent + 1'b1;
                end
                state <= OUTPUT_GENERATION;
            end
            OUTPUT_GENERATION: begin
                // Format result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule