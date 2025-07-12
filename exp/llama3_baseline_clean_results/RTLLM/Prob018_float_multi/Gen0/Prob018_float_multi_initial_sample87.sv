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

// Finite State Machine states
enum logic [2:0] {IDLE, INPUT_PROCESS, SPECIAL_CASES, NORMALIZE, MULTIPLY, ROUND_ADJUST, OUTPUT_GEN} state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000; // Reset counter
        state <= IDLE; // Reset FSM state
    end else begin
        case (state)
            IDLE: begin
                if (a !== 32'b0 && b !== 32'b0) begin
                    next_state <= INPUT_PROCESS;
                end else begin
                    next_state <= IDLE;
                end
            end
            INPUT_PROCESS: begin
                a_mantissa <= a[22:0]; // Extract mantissa from 'a'
                a_exponent <= a[30:23]; // Extract exponent from 'a'
                a_sign <= a[31]; // Extract sign bit from 'a'
                b_mantissa <= b[22:0]; // Extract mantissa from 'b'
                b_exponent <= b[30:23]; // Extract exponent from 'b'
                b_sign <= b[31]; // Extract sign bit from 'b'
                next_state <= SPECIAL_CASES;
            end
            SPECIAL_CASES: begin
                // Handling special cases like NaN and infinity
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    // Either 'a' or 'b' is NaN or infinity
                    z <= (a_exponent == 9'b11111111) ? a : b; // Propagate NaN or infinity
                end else begin
                    next_state <= NORMALIZE;
                end
            end
            NORMALIZE: begin
                // Normalize mantissas if needed
                a_mantissa <= (a_exponent != 0) ? {1'b1, a_mantissa} : a_mantissa;
                b_mantissa <= (b_exponent != 0) ? {1'b1, b_mantissa} : b_mantissa;
                next_state <= MULTIPLY;
            end
            MULTIPLY: begin
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa}; // Multiply mantissas
                z_exponent <= a_exponent + b_exponent - 127; // Adjust exponent
                z_sign <= a_sign ^ b_sign; // Combine sign bits
                next_state <= ROUND_ADJUST;
            end
            ROUND_ADJUST: begin
                // Round the result and adjust the exponent
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0]; // Calculate sticky bit
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa <= product[46:23] + 1'b1;
                    if (z_mantissa == 24'b1) begin
                        // Mantissa overflow, increment exponent
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= 23'b0;
                    end
                end else begin
                    z_mantissa <= product[46:23];
                end
                next_state <= OUTPUT_GEN;
            end
            OUTPUT_GEN: begin
                // Format the result in IEEE 754 standard
                z <= {z_sign, z_exponent[7:0], z_mantissa};
                next_state <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
        counter <= counter + 1'b1; // Increment cycle counter
        state <= next_state; // Update FSM state
    end
end

endmodule