module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(*) begin
    // Extraction of mantissas, exponents, and signs
    a_mantissa = a[22:0];
    a_exponent = a[30:23];
    a_sign = a[31];
    
    b_mantissa = b[22:0];
    b_exponent = b[30:23];
    b_sign = b[31];
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'h0;
    end else begin
        case (counter)
            3'b000: begin
                // Handle special cases (NaN, Infinity)
                if ((a_exponent == 9'hFF && a_mantissa != 0) || (b_exponent == 9'hFF && b_mantissa != 0)) begin
                    // Result is NaN if either operand is NaN
                    z <= 32'h7FC00000; // Quiet NaN
                end else if ((a_exponent == 9'hFF && a_mantissa == 0) || (b_exponent == 9'hFF && b_mantissa == 0)) begin
                    // Result is Infinity if either operand is Infinity
                    if (a_sign ^ b_sign) begin
                        z <= 32'hFFC00000; // Negative Infinity
                    end else begin
                        z <= 32'h7F800000; // Positive Infinity
                    end
                end else begin
                    // Normalize mantissas if necessary
                    if (a_exponent == 0) begin
                        // Handle subnormal numbers for a
                        // For simplicity, assume no subnormal inputs
                    end
                    if (b_exponent == 0) begin
                        // Handle subnormal numbers for b
                        // For simplicity, assume no subnormal inputs
                    end
                    
                    // Increment counter to next step
                    counter <= counter + 1;
                end
            end
            
            3'b001: begin
                // Multiply mantissas
                product = a_mantissa * b_mantissa;
                
                // Calculate new exponent
                z_exponent = a_exponent + b_exponent - 127; // Bias for single precision
                
                // Determine sign of result
                z_sign = a_sign ^ b_sign;
                
                // Increment counter
                counter <= counter + 1;
            end
            
            3'b010: begin
                // Rounding and adjustment
                // For simplicity, we'll implement a basic rounding scheme
                guard_bit = product[48];
                round_bit = product[47];
                sticky = |product[46:0];
                
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa = product[47:24] + 1;
                    if (z_mantissa == 24'h1000000) begin
                        // Carry to exponent
                        z_exponent = z_exponent + 1;
                        z_mantissa = 24'h0;
                    end
                end else begin
                    z_mantissa = product[47:24];
                end
                
                // Handle overflow
                if (z_exponent > 254) begin
                    z <= 32'h7F800000; // Positive Infinity
                end else if (z_exponent < -126) begin
                    z <= 32'h0; // Underflow to zero
                end else begin
                    // Format result
                    z <= {z_sign, z_exponent + 127, z_mantissa};
                end
                
                // Reset counter
                counter <= 3'b000;
            end
            
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule