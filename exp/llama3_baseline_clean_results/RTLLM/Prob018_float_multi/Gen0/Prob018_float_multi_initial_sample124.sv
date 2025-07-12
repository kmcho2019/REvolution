module float_multi(
    input         clk,            // Clock signal
    input         rst,            // Reset signal (active high)
    input  [31:0] a,              // First operand in IEEE 754 format
    input  [31:0] b,              // Second operand in IEEE 754 format
    output reg [31:0] z            // Result of the multiplication in IEEE 754 format
);

reg [2:0] counter;                // Cycle counter for operation sequencing

// Extracted components of the input numbers
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent; // Using 9 bits to handle bias and overflow
reg a_sign, b_sign, z_sign;

// Intermediate product and rounding control bits
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// FSM states
localparam IDLE = 3'b001, EXTRACT = 3'b010, HANDLE_SPECIAL_CASES = 3'b011, 
             NORMALIZE = 3'b100, MULTIPLY = 3'b101, ROUND_ADJUST = 3'b110, 
             OUTPUT_GEN = 3'b111;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all internal signals and state
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            IDLE: begin
                // Move to extract state
                counter <= EXTRACT;
            end
            EXTRACT: begin
                // Extract mantissas, exponents, and signs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                // Move to special cases handling
                counter <= HANDLE_SPECIAL_CASES;
            end
            HANDLE_SPECIAL_CASES: begin
                // Check for NaN and infinity
                if ((a_exponent == 9'b111111111) || (b_exponent == 9'b111111111)) begin
                    // Handle special cases, e.g., NaN or infinity
                    z <= (a_exponent == 9'b111111111) ? a : b; // Simplified handling, actual implementation depends on IEEE 754 requirements
                    counter <= IDLE;
                end else begin
                    // Move to normalization
                    counter <= NORMALIZE;
                end
            end
            NORMALIZE: begin
                // Normalize mantissas if necessary
                if (a_mantissa[23] == 1'b0) begin
                    // Left shift mantissa until MSB is 1, decrement exponent
                    a_mantissa <= {a_mantissa[22:0], 1'b0};
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // Left shift mantissa until MSB is 1, decrement exponent
                    b_mantissa <= {b_mantissa[22:0], 1'b0};
                    b_exponent <= b_exponent - 1'b1;
                end
                // Move to multiplication
                counter <= MULTIPLY;
            end
            MULTIPLY: begin
                // Multiply mantissas and adjust signs
                product <= (a_mantissa * b_mantissa);
                z_sign <= a_sign ^ b_sign;
                // Calculate new exponent
                z_exponent <= a_exponent + b_exponent - 127; // Bias for single precision
                // Move to rounding and adjustment
                counter <= ROUND_ADJUST;
            end
            ROUND_ADJUST: begin
                // Round product and adjust exponent
                // This step is simplified; actual implementation involves checking guard, round, and sticky bits
                if (product[0] == 1'b1) begin
                    // Round up
                    z_mantissa <= product[23:1] + 1'b1;
                    if (z_mantissa[23] == 1'b1) begin
                        // Overflow, increment exponent
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= z_mantissa[22:0];
                    end
                end else begin
                    z_mantissa <= product[23:1];
                end
                // Move to output generation
                counter <= OUTPUT_GEN;
            end
            OUTPUT_GEN: begin
                // Construct final output in IEEE 754 format
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= IDLE;
            end
            default: counter <= IDLE;
        endcase
    end
end

endmodule