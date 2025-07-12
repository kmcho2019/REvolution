module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;  // 24x24 multiplication (reduced from 49 to 48 bits)
    reg guard_bit, round_bit, sticky;
    reg special_case;
    reg [31:0] special_result;
    
    // Pipelined multiplier registers
    reg [23:0] mult_a, mult_b;
    reg [47:0] partial_product;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
            special_case <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 1: Input processing and early special case detection
                    // Early special case detection
                    if ((&a[30:23] && (|a[22:0])) ||  // a is NaN
                        (&b[30:23] && (|b[22:0])) ||  // b is NaN
                        (&a[30:23] && &b[30:23]) ||   // both inf
                        ((a[30:0] == 0) && (&b[30:23])) ||  // 0 * inf
                        ((b[30:0] == 0) && (&a[30:23]))) begin  // inf * 0
                        special_case <= 1;
                        if ((&a[30:23] && (|a[22:0])) || (&b[30:23] && (|b[22:0]))) begin
                            special_result <= 32'h7FC00000;  // NaN
                        end else if ((a[30:0] == 0) || (b[30:0] == 0) begin
                            special_result <= {a[31] ^ b[31], 31'b0};  // +/- 0
                        end else begin
                            special_result <= {a[31] ^ b[31], 8'hFF, 23'b0};  // +/- inf
                        end
                        counter <= 4;  // Skip to output
                    end else begin
                        // Extract sign bits
                        a_sign <= a[31];
                        b_sign <= b[31];
                        
                        // Extract and bias exponents (8-bit)
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        
                        // Extract mantissas (with implicit 1)
                        a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        // Start pipelined multiplication
                        mult_a <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        mult_b <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        counter <= counter + 1;
                    end
                end
                
                1: begin  // Cycle 2: First stage of pipelined multiplication
                    // Compute partial product (lower 24 bits)
                    partial_product <= mult_a * mult_b[11:0];
                    mult_b <= mult_b;  // Hold for second stage
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Second stage of multiplication and exponent add
                    // Complete multiplication (upper 12 bits)
                    product <= partial_product + (mult_a * mult_b[23:12]) << 12;
                    
                    // Add exponents and subtract bias (127)
                    z_exponent <= a_exponent + b_exponent - 8'd127;
                    
                    // XOR sign bits
                    z_sign <= a_sign ^ b_sign;
                    
                    counter <= counter + 1;
                end
                
                3: begin  // Cycle 4: Normalization and rounding
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
                    
                    // Combined rounding and normalization
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin  // If mantissa overflows
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    counter <= counter + 1;
                end
                
                4: begin  // Cycle 5: Output
                    if (special_case) begin
                        z <= special_result;
                        special_case <= 0;
                    end
                    // Handle overflow
                    else if (&z_exponent || (z_exponent >= 8'hFE)) begin
                        z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                    end
                    // Handle underflow
                    else if (z_exponent[7] || (z_exponent == 0)) begin  // exp <= 0
                        z <= {z_sign, 31'b0};  // +/- 0
                    end
                    // Normal case
                    else begin
                        z <= {z_sign, z_exponent, z_mantissa[22:0]};
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule