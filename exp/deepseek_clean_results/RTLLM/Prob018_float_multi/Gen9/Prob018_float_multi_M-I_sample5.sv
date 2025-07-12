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
    reg [47:0] product;  // 24x24 multiplication (optimized from 49 to 48 bits)
    reg guard_bit, round_bit, sticky;
    reg special_case;
    reg [23:0] partial_prod [0:3];  // For pipelined multiplication
    reg [9:0] exp_sum;  // Temporary exponent sum
    
    // Clock gating signals
    wire stage1_en = (counter == 0) || rst;
    wire stage2_en = (counter == 1);
    wire stage3_en = (counter == 2);
    wire stage4_en = (counter == 3);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
            special_case <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 0: Input processing and special cases
                    if (stage1_en) begin
                        // Extract sign bits
                        a_sign <= a[31];
                        b_sign <= b[31];
                        
                        // Extract exponents
                        a_exponent <= a[30:23];
                        b_exponent <= b[30:23];
                        
                        // Extract mantissas (with implicit 1)
                        a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        // Combined special case detection
                        special_case <= (&a[30:23]) || (&b[30:23]) || (a[30:0] == 0) || (b[30:0] == 0);
                        
                        // Calculate partial products for pipelined multiplication
                        partial_prod[0] <= b_mantissa * a_mantissa[5:0];
                        partial_prod[1] <= (b_mantissa * a_mantissa[11:6]) << 6;
                        partial_prod[2] <= (b_mantissa * a_mantissa[17:12]) << 12;
                        partial_prod[3] <= (b_mantissa * a_mantissa[23:18]) << 18;
                        
                        // Temporary exponent sum with carry-save
                        exp_sum <= {2'b0, a_exponent} + {2'b0, b_exponent} - 10'd127;
                        
                        counter <= counter + 1;
                    end
                end
                
                1: begin  // Cycle 1: Final multiplication and exponent
                    if (stage2_en) begin
                        // Final addition of partial products
                        product <= partial_prod[0] + partial_prod[1] + partial_prod[2] + partial_prod[3];
                        
                        // Final exponent calculation (convert to 8-bit)
                        z_exponent <= exp_sum[7:0];
                        z_sign <= a_sign ^ b_sign;
                        
                        counter <= counter + 1;
                    end
                end
                
                2: begin  // Cycle 2: Normalization and rounding prep
                    if (stage3_en) begin
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
                end
                
                3: begin  // Cycle 3: Rounding and output
                    if (stage4_en) begin
                        if (special_case) begin
                            // Handle special cases
                            if ((&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0]) begin
                                z <= 32'h7FC00000;  // NaN
                            end else if ((&a[30:23] || &b[30:23]) && (a[30:0] != 0 && b[30:0] != 0) begin
                                z <= {z_sign, 8'hFF, 23'b0};  // Infinity
                            end else begin
                                z <= {z_sign, 31'b0};  // Zero
                            end
                        end else begin
                            // Round to nearest even
                            if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                                z_mantissa <= z_mantissa + 1;
                                if (&z_mantissa) begin  // If mantissa overflows
                                    z_mantissa <= {1'b1, 23'b0};
                                    z_exponent <= z_exponent + 1;
                                end
                            end
                            
                            // Handle normal cases with overflow/underflow check
                            if (z_exponent[7] && z_exponent != 8'hFF) begin  // Underflow
                                z <= {z_sign, 31'b0};
                            end else if (&z_exponent) begin  // Overflow
                                z <= {z_sign, 8'hFF, 23'b0};
                            end else begin
                                z <= {z_sign, z_exponent, z_mantissa[22:0]};
                            end
                        end
                        
                        counter <= 0;
                    end
                end
            endcase
        end
    end

endmodule