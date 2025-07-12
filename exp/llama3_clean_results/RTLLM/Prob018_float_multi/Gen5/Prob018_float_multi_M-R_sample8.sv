module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

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

// Reset logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000; // Reset state
        z <= 32'b0; // Reset output
    end else begin
        case (state)
            3'b000: begin // Initial state
                // Check for NaN or Infinity
                if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
                    if ((a_exponent == 9'b11111111) && (a_mantissa!= 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 23'b0)) begin
                        z <= 32'b1; // NaN
                    end else if (a_exponent == 9'b11111111) begin
                        z <= (a_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end else begin
                        z <= (b_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
                    end
                    state <= 3'b001; // Move to output state
                end else begin
                    z_sign <= a_sign ^ b_sign; // Determine sign of result
                    z_exponent <= a_exponent + b_exponent - 9'b10000000; // Calculate new exponent
                    
                    // Check for overflow
                    if (z_exponent > 9'b11111110) begin
                        z_exponent <= 9'b11111111; // Set to infinity
                        z_mantissa <= 23'b0;
                    end
                    
                    // Check for underflow
                    if (z_exponent < 9'b1) begin
                        z_exponent <= 9'b0; // Set to zero
                        z_mantissa <= 23'b0;
                    end
                    
                    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa}; // Multiply mantissas
                    state <= 3'b010; // Move to multiplication state
                end
            end
            3'b010: begin // Multiplication state
                // Rounding and Adjustment
                guard_bit <= product[24];
                round_bit <= product[23];
                sticky <= |product[22:0]; // Simplified sticky bit calculation
                
                if (guard_bit || round_bit || sticky) begin
                    z_mantissa <= product[48:25] + 1;
                end else begin
                    z_mantissa <= product[48:25];
                end
                
                // Normalize the mantissa
                if (z_mantissa[23] == 1'b0) begin
                    z_mantissa <= z_mantissa << 1;
                    z_exponent <= z_exponent - 1;
                end
                
                state <= 3'b001; // Move to output state
            end
            3'b001: begin // Output state
                // Output Generation
                z <= {z_sign, z_exponent, z_mantissa};
                state <= 3'b000; // Reset state
            end
        endcase
    end
end

endmodule