module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State variable
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Extract inputs
assign a_sign = a[31]; // Extract sign bit of a
assign a_exponent = a[30:23]; // Extract exponent of a
assign a_mantissa = a[22:0]; // Extract mantissa of a
assign b_sign = b[31]; // Extract sign bit of b
assign b_exponent = b[30:23]; // Extract exponent of b
assign b_mantissa = b[22:0]; // Extract mantissa of b

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000; // Reset state
        z <= 32'b0; // Reset output
    end else begin
        case (state)
            3'b000: begin // Initial state
                // Check for special cases
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    if ((a_exponent == 9'b11111111) && (a_mantissa != 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 9'b11111111) && (b_mantissa != 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if (a_exponent == 9'b11111111) begin
                        z <= (a_sign) ? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end else begin
                        z <= (b_sign) ? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end
                    state <= 3'b001; // Move to output state
                end else begin
                    // Calculate new exponent and sign
                    z_sign <= a_sign ^ b_sign;
                    z_exponent <= a_exponent + b_exponent - 9'b10000000;
                    
                    // Check for overflow and underflow
                    if (z_exponent > 9'b11111110) begin
                        z_exponent <= 9'b11111111; // Set to infinity
                        z_mantissa <= 23'b0;
                    end else if (z_exponent < 9'b1) begin
                        z_exponent <= 9'b0; // Set to zero
                        z_mantissa <= 23'b0;
                    end
                    
                    // Multiply mantissas
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                    state <= 3'b010; // Move to multiplication state
                end
            end
            3'b010: begin // Multiplication state
                // Rounding and normalization
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0];
                
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[48:25] + 1;
                end else begin
                    z_mantissa <= product[48:25];
                end
                
                // Normalize mantissa
                if (z_mantissa[23] == 1'b0) begin
                    z_mantissa <= z_mantissa << 1;
                    z_exponent <= z_exponent - 1;
                end
                
                state <= 3'b001; // Move to output state
            end
            3'b001: begin // Output state
                // Format output
                z <= {z_sign, z_exponent, z_mantissa};
                state <= 3'b000; // Reset state
            end
        endcase
    end
end

endmodule