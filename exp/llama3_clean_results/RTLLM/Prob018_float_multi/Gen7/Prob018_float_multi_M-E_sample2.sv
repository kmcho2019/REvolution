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
reg [31:0] lut_result; // Lookup table result

// Lookup table (LUT) for common multiplication results
always @(a_mantissa, b_mantissa) begin
    case ({a_mantissa, b_mantissa})
        24'b0000_0000_0000_0000_0000_0000_0000_0001: lut_result <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // 1.0 * 1.0 = 1.0
        24'b0000_0000_0000_0000_0000_0000_0000_0010: lut_result <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // 1.0 * 2.0 = 2.0
        // Add more common cases to the LUT as needed
        default: lut_result <= 32'b0; // Default value
    endcase
end

// Pipeline stage 1: Input processing and exponent calculation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000; // Reset state
        z <= 32'b0; // Reset output
    end else if (state == 3'b000) begin
        // Extract inputs
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        
        // Check for special cases (early outs)
        if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
            // Handle NaN and infinity cases
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
            
            // Check if result is in the LUT
            if (lut_result != 32'b0) begin
                z <= lut_result;
                state <= 3'b001; // Move to output state
            end else begin
                state <= 3'b010; // Move to multiplication state
            end
        end
    end
end

// Pipeline stage 2: Multiplication
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset
    end else if (state == 3'b010) begin
        // Multiply mantissas
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        state <= 3'b011; // Move to rounding state
    end
end

// Pipeline stage 3: Rounding and normalization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset
    end else if (state == 3'b011) begin
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
end

// Pipeline stage 4: Output formatting
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset
    end else if (state == 3'b001) begin
        // Format output
        z <= {z_sign, z_exponent, z_mantissa};
        state <= 3'b000; // Reset state
    end
end

endmodule