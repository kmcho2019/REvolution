module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    
    // Special case flags
    reg a_is_nan, a_is_inf, a_is_zero;
    reg b_is_nan, b_is_inf, b_is_zero;
    reg z_is_nan, z_is_inf, z_is_zero;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'h0;
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
                    
                    // Extract mantissas (with implicit 1)
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Check for special cases
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);
                    a_is_inf <= (&a[30:23]) && (~|a[22:0]);
                    b_is_inf <= (&b[30:23]) && (~|b[22:0]);
                    a_is_zero <= ~|a[30:0];
                    b_is_zero <= ~|b[30:0];
                end
                
                1: begin // Cycle 2: Multiplication
                    // Multiply mantissas (24x24=48 bits)
                    product <= a_mantissa * b_mantissa;
                    
                    // Add exponents (with bias adjustment)
                    z_exponent <= a_exponent + b_exponent - 10'd127;
                    
                    // Calculate sign
                    z_sign <= a_sign ^ b_sign;
                    
                    // Handle special cases
                    z_is_nan <= a_is_nan || b_is_nan || 
                               (a_is_inf && b_is_zero) || 
                               (b_is_inf && a_is_zero);
                    z_is_inf <= (a_is_inf || b_is_inf) && !z_is_nan;
                    z_is_zero <= a_is_zero || b_is_zero;
                end
                
                2: begin // Cycle 3: Normalization and rounding
                    if (z_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // Quiet NaN
                    end else if (z_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (z_is_zero) begin
                        z <= {z_sign, 31'h0}; // Zero
                    end else begin
                        // Normalize product
                        if (product[47]) begin
                            product <= product >> 1;
                            z_exponent <= z_exponent + 1;
                        end
                        
                        // Extract rounding bits
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                        
                        // Round to nearest even
                        if (guard_bit && (round_bit || sticky || product[23])) begin
                            z_mantissa <= product[46:24] + 1;
                            if (&product[46:24]) begin // Overflow in mantissa
                                z_mantissa <= 24'h800000;
                                z_exponent <= z_exponent + 1;
                            end
                        end else begin
                            z_mantissa <= product[46:24];
                        end
                        
                        // Check for exponent overflow/underflow
                        if (z_exponent[9] || (z_exponent >= 10'd255)) begin // Overflow
                            z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                        end else if (z_exponent <= 0) begin // Underflow
                            z <= {z_sign, 31'h0}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end
                    
                    counter <= 0; // Reset counter for next operation
                end
            endcase
        end
    end

endmodule