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
    reg [23:0] partial_prod [0:23];  // Partial products for pipelined mult
    reg [47:0] product;              // Final product
    reg guard_bit, round_bit, sticky;
    reg special_case;

    // Clock gating signals
    wire clk_gated = clk & (|counter || rst);

    always @(posedge clk_gated or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin  // Cycle 1: Input processing
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];
                    
                    // Extract exponents and mantissas
                    exp_sum <= {2'b0, a[30:23]} + {2'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Generate partial products (first stage of multiplication)
                    for (integer i = 0; i < 24; i = i + 1) begin
                        partial_prod[i] <= b_mantissa[i] ? a_mantissa : 24'b0;
                    end
                    
                    // Check for special cases
                    special_case <= (&a[30:23] || (&b[30:23]) || 
                                  (a[30:0] == 0) || (b[30:0] == 0);
                    
                    counter <= counter + 1;
                end
                
                1: begin  // Cycle 2: Complete multiplication and exponent
                    // Sum partial products (second stage of multiplication)
                    product <= {24'b0, partial_prod[0]};
                    for (integer i = 1; i < 24; i = i + 1) begin
                        product <= product + ({partial_prod[i], i'b0});
                    end
                    
                    // Final exponent with bias adjustment
                    z_exponent <= exp_sum - 8'd127;
                    z_sign <= a_sign ^ b_sign;
                    
                    counter <= counter + 1;
                end
                
                2: begin  // Cycle 3: Normalization and rounding
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
                    
                    // Combined rounding and overflow check
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin  // If mantissa overflows
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    counter <= counter + 1;
                end
                
                3: begin  // Cycle 4: Output with special case handling
                    if (special_case) begin
                        // Handle NaN
                        if ((&a[30:23] && |a[22:0]) || (&b[30:23] && |b[22:0]) ||
                            ((&a[30:23] && a[22:0] == 0) && (b[30:0] == 0)) begin
                            z <= 32'h7FC00000;  // NaN
                        end
                        // Handle infinity
                        else if ((&a[30:23] && a[22:0] == 0) || (&b[30:23] && b[22:0] == 0)) begin
                            z <= {z_sign, 8'hFF, 23'b0};  // +/- inf
                        end
                        // Handle zero
                        else begin
                            z <= {z_sign, 31'b0};  // +/- 0
                        end
                    end
                    // Handle overflow/underflow
                    else if (z_exponent[7] && z_exponent != 8'hFF) begin  // Underflow
                        z <= {z_sign, 31'b0};
                    end
                    else if (z_exponent == 8'hFF) begin  // Overflow
                        z <= {z_sign, 8'hFF, 23'b0};
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