module float_multi(
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
    reg [47:0] product;  // 24x24 multiplication
    reg guard_bit, round_bit, sticky;
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 1: Input processing and special cases
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
                    a_zero <= (a[30:0] == 0);
                    b_zero <= (b[30:0] == 0);
                    a_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_nan <= (&a[30:23]) && (|a[22:0]);
                    b_nan <= (&b[30:23]) && (|b[22:0]);
                    
                    counter <= counter + 1;
                end
                
                1: begin  // Cycle 2: Multiply mantissas and add exponents
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;
                    
                    // Add exponents and subtract bias (127)
                    z_exponent <= a_exponent + b_exponent - 10'd127;
                    
                    // XOR sign bits
                    z_sign <= a_sign ^ b_sign;
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Normalization
                    if (product[47]) begin  // Product >= 2
                        z_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                    end
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    counter <= counter + 1;
                end
                
                3: begin  // Cycle 4: Rounding
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin  // If mantissa overflows
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    counter <= counter + 1;
                end
                
                4: begin  // Cycle 5: Handle special cases and output
                    // Handle NaN
                    if (a_nan || b_nan) begin
                        z <= 32'h7FC00000;  // Canonical NaN
                    end
                    // Handle infinity
                    else if (a_inf || b_inf) begin
                        if (a_zero || b_zero) begin
                            z <= 32'h7FC00000;  // inf * 0 = NaN
                        end else begin
                            z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                        end
                    end
                    // Handle zero
                    else if (a_zero || b_zero) begin
                        z <= {z_sign, 31'b0};  // +/- 0
                    end
                    // Handle overflow
                    else if (z_exponent[9] || (&z_exponent[7:0])) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                    end
                    // Handle underflow
                    else if (z_exponent[8] || (z_exponent == 0)) begin
                        z <= {z_sign, 31'b0};  // +/- 0 (denormal handled as 0)
                    end
                    // Normal case
                    else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule