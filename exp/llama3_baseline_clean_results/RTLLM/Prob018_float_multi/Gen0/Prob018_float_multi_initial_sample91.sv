module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize counter on reset
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        case (counter)
            3'b000: counter <= 3'b001; // Extract inputs
            3'b001: counter <= 3'b010; // Special cases and normalization
            3'b010: counter <= 3'b011; // Multiply and adjust
            3'b011: counter <= 3'b100; // Round and finalize
            3'b100: counter <= 3'b000; // Output result
        endcase
    end
end

// Input processing
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Extract mantissas, exponents, and signs
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        a_sign <= a[31];
        b_sign <= b[31];
    end
end

// Special cases handling and normalization
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Check for NaN or infinity
        if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
            // Handle NaN or infinity cases
            z_sign <= a_sign || b_sign;
            z_exponent <= 9'b11111111;
            z_mantissa <= 24'b0;
        end else if ((a_exponent == 0) || (b_exponent == 0)) begin
            // Handle zero cases
            z_sign <= a_sign || b_sign;
            z_exponent <= 1'b0;
            z_mantissa <= 24'b0;
        end else begin
            // Normalize mantissas if needed
            if (a_mantissa[23] == 1'b0) begin
                a_mantissa <= {1'b1, a_mantissa[22:0]};
                a_exponent <= a_exponent - 1'b1;
            end
            if (b_mantissa[23] == 1'b0) begin
                b_mantissa <= {1'b1, b_mantissa[22:0]};
                b_exponent <= b_exponent - 1'b1;
            end
        end
    end
end

// Multiplication and adjustment
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Multiply mantissas
        product <= a_mantissa * b_mantissa;
        
        // Combine signs
        z_sign <= a_sign ^ b_sign;
        
        // Adjust exponent
        z_exponent <= a_exponent + b_exponent - 9'b01111011; // Bias 127
        
        // Extract result mantissa
        z_mantissa <= product[49:26];
        
        // Extract guard, round, and sticky bits
        guard_bit <= product[25];
        round_bit <= product[24];
        sticky <= |product[23:0];
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Round result
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= z_mantissa + 1'b1;
            if (z_mantissa[23] == 1'b1) begin
                z_exponent <= z_exponent + 1'b1;
                z_mantissa <= z_mantissa[22:0];
            end
        end
        
        // Adjust for overflow
        if (z_exponent > 9'b11111110) begin
            z_exponent <= 9'b11111111;
            z_mantissa <= 24'b0;
        end
        
        // Adjust for underflow
        if (z_exponent < 1'b0) begin
            z_exponent <= 1'b0;
            z_mantissa <= 24'b0;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Format result in IEEE 754 standard
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

endmodule