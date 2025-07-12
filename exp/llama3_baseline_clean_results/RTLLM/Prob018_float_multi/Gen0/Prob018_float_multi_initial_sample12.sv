module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;  // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa;  // Mantissas of input and output numbers
reg [7:0] a_exponent, b_exponent, z_exponent;  // Exponents of input and output numbers
reg a_sign, b_sign, z_sign;  // Sign bits for inputs and output
reg [47:0] product;  // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky;  // Rounding control bits
reg [1:0] state;  // State machine states

// State machine states
localparam IDLE = 2'b00;
localparam SPECIAL_CASES = 2'b01;
localparam NORMALIZATION = 2'b10;
localparam MULTIPLICATION = 2'b11;
localparam ROUNDING = 3'b100;
localparam OUTPUT = 3'b101;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        state <= IDLE;
        z <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                // Extract mantissas, exponents, and sign bits of inputs a and b
                a_mantissa <= a[22:0];
                a_exponent <= a[30:23];
                a_sign <= a[31];
                b_mantissa <= b[22:0];
                b_exponent <= b[30:23];
                b_sign <= b[31];
                state <= SPECIAL_CASES;
            end
            SPECIAL_CASES: begin
                // Check for special cases (NaN, infinity)
                if ((a_exponent == 8'b11111111) || (b_exponent == 8'b11111111)) begin
                    // Handle infinity
                    if (a_exponent == 8'b11111111) begin
                        z_sign <= a_sign;
                        z_exponent <= 8'b11111111;
                        z_mantissa <= 24'b0;
                    end else begin
                        z_sign <= b_sign;
                        z_exponent <= 8'b11111111;
                        z_mantissa <= 24'b0;
                    end
                    state <= OUTPUT;
                end else if ((a_exponent == 8'b0) && (a_mantissa != 24'b0)) begin
                    // Handle NaN (a)
                    z_sign <= a_sign;
                    z_exponent <= 8'b11111111;
                    z_mantissa <= 24'b1;
                    state <= OUTPUT;
                end else if ((b_exponent == 8'b0) && (b_mantissa != 24'b0)) begin
                    // Handle NaN (b)
                    z_sign <= b_sign;
                    z_exponent <= 8'b11111111;
                    z_mantissa <= 24'b1;
                    state <= OUTPUT;
                end else begin
                    state <= NORMALIZATION;
                end
            end
            NORMALIZATION: begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    // Normalize a_mantissa
                    a_mantissa <= {1'b1, a_mantissa[22:0]};
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // Normalize b_mantissa
                    b_mantissa <= {1'b1, b_mantissa[22:0]};
                    b_exponent <= b_exponent - 1'b1;
                end
                state <= MULTIPLICATION;
            end
            MULTIPLICATION: begin
                // Multiply mantissas and combine signs
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 8'b01111111;  // Bias subtraction
                state <= ROUNDING;
            end
            ROUNDING: begin
                // Round result
                guard_bit <= product[1];
                round_bit <= product[0];
                sticky <= |product[0:-1];
                if ((guard_bit == 1'b1) && ((round_bit == 1'b1) || sticky == 1'b1)) begin
                    // Round up
                    z_mantissa <= product[47:24] + 1'b1;
                    if (z_mantissa[23] == 1'b1) begin
                        // Overflow
                        z_mantissa <= 24'b0;
                        z_exponent <= z_exponent + 1'b1;
                    end
                end else begin
                    // Round down
                    z_mantissa <= product[47:24];
                end
                state <= OUTPUT;
            end
            OUTPUT: begin
                // Generate final output
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