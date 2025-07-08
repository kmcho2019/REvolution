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
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin // Cycle 1: Input processing and special case detection
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];
                    
                    // Extract exponents
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    
                    // Extract mantissas (with implicit leading 1)
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);
                    
                    counter <= 1;
                end
                
                1: begin // Cycle 2: Handle special cases and prepare multiplication
                    // Handle NaN cases (NaN * anything = NaN)
                    if (a_is_nan || b_is_nan) begin
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'h0FF;
                        z_mantissa <= {1'b1, 22'b0}; // Quiet NaN
                        counter <= 3;
                    end
                    // Handle infinity cases
                    else if (a_is_inf || b_is_inf) begin
                        if (a_is_zero || b_is_zero) begin
                            // Infinity * 0 = NaN
                            z_sign <= a_sign ^ b_sign;
                            z_exponent <= 10'h0FF;
                            z_mantissa <= {1'b1, 22'b0}; // Quiet NaN
                        end else begin
                            // Infinity * non-zero = Infinity
                            z_sign <= a_sign ^ b_sign;
                            z_exponent <= 10'h0FF;
                            z_mantissa <= 0;
                        end
                        counter <= 3;
                    end
                    // Handle zero cases
                    else if (a_is_zero || b_is_zero) begin
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 0;
                        z_mantissa <= 0;
                        counter <= 3;
                    end
                    else begin
                        // Normal case: perform multiplication
                        // Add exponents (subtract bias 127)
                        z_exponent <= a_exponent + b_exponent - 10'd127;
                        
                        // Multiply mantissas (24x24 -> 48 bit product)
                        product <= a_mantissa * b_mantissa;
                        
                        counter <= 2;
                    end
                end
                
                2: begin // Cycle 3: Normalization and rounding
                    // Check if product needs normalization (MSB should be 1)
                    if (product[47]) begin
                        // Already normalized (1x.xxxx...)
                        z_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        // Shift left by 1
                        z_mantissa <= product[45:22];
                        guard_bit <= product[21];
                        round_bit <= product[20];
                        sticky <= |product[19:0];
                    end
                    
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        // Check for mantissa overflow (all 1's + 1)
                        if (&z_mantissa) begin
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    counter <= 3;
                end
                
                3: begin // Cycle 4: Final adjustments and output
                    // Handle exponent overflow (>= 255)
                    if (z_exponent[9] || (&z_exponent[7:0])) begin
                        z_exponent <= 10'h0FF;
                        z_mantissa <= 0;
                    end
                    // Handle exponent underflow (<= 0)
                    else if (z_exponent < 10'd127) begin
                        // Gradual underflow (denormal)
                        if (z_exponent > 10'd127 - 24) begin
                            z_mantissa <= z_mantissa >> (10'd127 - z_exponent);
                            z_exponent <= 0;
                        end
                        // Complete underflow (zero)
                        else begin
                            z_exponent <= 0;
                            z_mantissa <= 0;
                        end
                    end
                    
                    // Combine final result
                    z[31] <= z_sign;
                    z[30:23] <= z_exponent[7:0];
                    z[22:0] <= z_mantissa[22:0];
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule