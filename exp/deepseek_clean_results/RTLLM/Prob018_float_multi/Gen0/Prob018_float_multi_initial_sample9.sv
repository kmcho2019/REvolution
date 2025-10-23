module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg [7:0] exponent_sum;
    reg [47:0] product_shifted;
    reg [22:0] mantissa_rounded;
    reg exponent_overflow, exponent_underflow;

    // Special case flags
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;
    reg z_is_zero, z_is_inf, z_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            counter <= counter + 1;
            
            case (counter)
                0: begin // Cycle 1: Input processing
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];
                    
                    // Extract exponents
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    
                    // Extract mantissas with implicit leading 1
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);
                end
                
                1: begin // Cycle 2: Multiplication
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;
                    
                    // Calculate exponent sum (subtract bias 127)
                    exponent_sum <= a_exponent + b_exponent - 127;
                    
                    // Determine result sign
                    z_sign <= a_sign ^ b_sign;
                    
                    // Handle special cases
                    z_is_nan <= a_is_nan | b_is_nan | (a_is_zero & b_is_inf) | (a_is_inf & b_is_zero);
                    z_is_inf <= (a_is_inf | b_is_inf) & ~z_is_nan;
                    z_is_zero <= (a_is_zero | b_is_zero) & ~z_is_nan;
                end
                
                2: begin // Cycle 3: Normalization and rounding
                    if (z_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
                    end else if (z_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0};
                    end else if (z_is_zero) begin
                        z <= {z_sign, 31'h0};
                    end else begin
                        // Normalize product (shift left if MSB is 0)
                        if (product[47]) begin
                            product_shifted <= product;
                            z_exponent <= exponent_sum + 1;
                        end else begin
                            product_shifted <= product << 1;
                            z_exponent <= exponent_sum;
                        end
                        
                        // Extract rounding bits
                        guard_bit <= product_shifted[22];
                        round_bit <= product_shifted[21];
                        sticky <= |product_shifted[20:0];
                        
                        // Round to nearest even
                        if (guard_bit & (round_bit | sticky | product_shifted[23])) begin
                            mantissa_rounded <= product_shifted[46:24] + 1;
                            // Check for mantissa overflow
                            if (mantissa_rounded[23]) begin
                                z_exponent <= z_exponent + 1;
                                mantissa_rounded <= {1'b0, mantissa_rounded[22:1]};
                            end
                        end else begin
                            mantissa_rounded <= product_shifted[46:24];
                        end
                        
                        // Check for exponent overflow/underflow
                        exponent_overflow <= (z_exponent >= 255);
                        exponent_underflow <= (z_exponent <= 0);
                        
                        // Final result assembly
                        if (exponent_overflow) begin
                            z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                        end else if (exponent_underflow) begin
                            z <= {z_sign, 31'h0}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], mantissa_rounded[22:0]};
                        end
                    end
                    
                    counter <= 0; // Reset counter for next operation
                end
            endcase
        end
    end

endmodule