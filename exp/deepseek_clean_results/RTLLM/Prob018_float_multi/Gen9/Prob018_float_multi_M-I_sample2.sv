module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] z_exponent;  // Reduced to 8 bits after bias adjustment
    reg [9:0] exp_sum;     // Temporary for exponent addition
    reg a_sign, b_sign, z_sign;
    reg [23:0] partial_prod [0:23];  // Partial products for pipelined multiply
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg special_case;

    // Clock gating signals
    wire cycle_active = ~rst & (counter != 3'd0 || |a || |b);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
            special_case <= 0;
        end else if (cycle_active) begin
            case (counter)
                0: begin  // Cycle 1: Input processing
                    // Sign calculation
                    z_sign <= a[31] ^ b[31];
                    
                    // Special case detection
                    special_case <= (&a[30:23] || &b[30:23] || 
                                   (a[30:0] == 0) || (b[30:0] == 0));
                    
                    // Exponent processing
                    exp_sum <= {2'b0, a[30:23]} + {2'b0, b[30:23]};
                    
                    // Mantissa processing with implicit 1
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Generate partial products
                    for (integer i = 0; i < 24; i = i + 1)
                        partial_prod[i] <= b_mantissa[i] ? (a_mantissa << i) : 0;
                    
                    counter <= counter + 1;
                end
                
                1: begin  // Cycle 2: Multiply stage 1 (partial product reduction)
                    // First level of Wallace tree reduction
                    product <= partial_prod[0] + partial_prod[1] + partial_prod[2];
                    
                    // Exponent adjustment
                    z_exponent <= exp_sum - 8'd127;
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Multiply stage 2 (final addition)
                    // Complete multiplication
                    product <= product + partial_prod[3] + partial_prod[4] + partial_prod[5];
                    // Additional reduction steps would go here in full implementation
                    
                    counter <= counter + 1;
                end
                
                3: begin  // Cycle 4: Normalization and rounding
                    if (product[47]) begin
                        z_mantissa <= product[47:24];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                    end
                    
                    // Rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    counter <= counter + 1;
                end
                
                4: begin  // Cycle 5: Final adjustment and output
                    if (special_case) begin
                        // Handle special cases
                        if ((&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0])) begin
                            z <= 32'h7FC00000;  // NaN
                        end else if ((&a[30:23] || &b[30:23]) && 
                                    ((a[30:0] == 0) || (b[30:0] == 0))) begin
                            z <= 32'h7FC00000;  // inf * 0 = NaN
                        end else if (&a[30:23] || &b[30:23]) begin
                            z <= {z_sign, 8'hFF, 23'b0};  // inf
                        end else begin
                            z <= {z_sign, 31'b0};  // zero
                        end
                    end else begin
                        // Round to nearest even
                        if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                            {z_mantissa, z_exponent} <= z_mantissa + 1;
                            if (&z_mantissa) begin  // Overflow after rounding
                                z_mantissa <= 24'h800000;
                                z_exponent <= z_exponent + 1;
                            end
                        end
                        
                        // Check for overflow/underflow
                        if (z_exponent[7] || (&z_exponent[6:0])) begin
                            z <= {z_sign, 8'hFF, 23'b0};  // inf
                        end else if (~|z_exponent) begin
                            z <= {z_sign, 31'b0};  // zero
                        end else begin
                            z <= {z_sign, z_exponent[6:0], z_mantissa[22:0]};
                        end
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule