// float_multi module implementation
module float_multi (
    input clk,  // Clock signal
    input rst,  // Reset signal (active high)
    input [31:0] a,  // First operand in IEEE 754 format
    input [31:0] b,  // Second operand in IEEE 754 format
    output reg [31:0] z  // Result of the multiplication in IEEE 754 format
);

// Internal signals
reg [2:0] counter;  // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa;  // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent;  // Exponents of input and output numbers
reg a_sign, b_sign, z_sign;  // Sign bits for inputs and output
reg [49:0] product;  // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky;  // Rounding control bits

// FSM states
parameter IDLE = 3'b000;
parameter INPUT_PROCESS = 3'b001;
parameter SPECIAL_CASES = 3'b010;
parameter NORMALIZATION = 3'b011;
parameter MULTIPLICATION = 3'b100;
parameter ROUNDING = 3'b101;
parameter OUTPUT_GENERATION = 3'b110;

// Current state
reg [2:0] current_state;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        current_state <= IDLE;
    end
    else begin
        case (current_state)
            IDLE: begin
                if (a != 32'd0 && b != 32'd0) begin
                    current_state <= INPUT_PROCESS;
                end
            end
            INPUT_PROCESS: begin
                // Extract mantissas, exponents, and sign bits
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                current_state <= SPECIAL_CASES;
            end
            SPECIAL_CASES: begin
                // Handle special cases like NaN and infinity
                if ((a_exponent == 9'd255 && a_mantissa != 23'd0) || (b_exponent == 9'd255 && b_mantissa != 23'd0)) begin
                    z <= 32'd0;  // NaN or infinity result
                end
                else if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
                    z_exponent <= 9'd255;
                    z_mantissa <= 23'd0;
                    z_sign <= a_sign ^ b_sign;
                    current_state <= OUTPUT_GENERATION;
                end
                else begin
                    current_state <= NORMALIZATION;
                end
            end
            NORMALIZATION: begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                    a_exponent <= a_exponent - 1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                    b_exponent <= b_exponent - 1;
                end
                current_state <= MULTIPLICATION;
            end
            MULTIPLICATION: begin
                // Multiply mantissas
                product <= a_mantissa * b_mantissa;
                z_exponent <= a_exponent + b_exponent - 127;
                current_state <= ROUNDING;
            end
            ROUNDING: begin
                // Round result and adjust exponent
                guard_bit <= product[49];
                round_bit <= product[48];
                sticky <= |product[47:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                end
                else begin
                    z_mantissa <= product[47:24];
                end
                if (z_mantissa[23] == 1'b1) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                current_state <= OUTPUT_GENERATION;
            end
            OUTPUT_GENERATION: begin
                // Format result in IEEE 754 standard
                z_sign <= a_sign ^ b_sign;
                z <= {z_sign, z_exponent, z_mantissa};
                current_state <= IDLE;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule