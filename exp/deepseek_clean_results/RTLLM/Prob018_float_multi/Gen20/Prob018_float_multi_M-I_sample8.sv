module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline control
    reg [1:0] stage;
    wire clk_gated;
    
    // Clock gating for power savings
    assign clk_gated = clk & (|stage || rst);
    
    // Stage 0 registers
    reg [22:0] a_mantissa_0, b_mantissa_0;
    reg [7:0] a_exponent_0, b_exponent_0;
    reg a_sign_0, b_sign_0;
    reg [2:0] special_flags_0; // [0]=nan, [1]=inf, [2]=zero
    
    // Stage 1 registers
    reg [23:0] a_mantissa_1, b_mantissa_1;
    reg [8:0] exp_sum_1;
    reg sign_1;
    reg [2:0] special_flags_1;
    reg [23:0] partial_prod_1 [0:3];
    
    // Stage 2 registers
    reg [46:0] product_2;
    reg [8:0] exp_sum_2;
    reg sign_2;
    reg [2:0] special_flags_2;
    
    // Stage 3 wires
    wire [4:0] lzd = product_2[46] ? 0 : 
                     product_2[45] ? 1 :
                     // ... (complete leading zero detection)
                     23;
    wire [46:0] shifted_product = product_2 << lzd;
    wire [8:0] adjusted_exp = exp_sum_2 - lzd;
    
    // Rounding logic
    wire guard_bit = shifted_product[22];
    wire round_bit = shifted_product[21];
    wire sticky = |shifted_product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || shifted_product[23]);
    wire [22:0] rounded_mantissa = shifted_product[46:24] + round_inc;
    
    // Overflow/underflow detection
    wire overflow = (adjusted_exp >= 255) || (&adjusted_exp[7:0] && round_inc);
    wire underflow = (adjusted_exp == 0) || (adjusted_exp[8]);
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    always @(posedge clk_gated or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            // Clear pipeline registers
            {a_mantissa_0, b_mantissa_0, a_exponent_0, b_exponent_0} <= 0;
            {a_sign_0, b_sign_0, special_flags_0} <= 0;
            {a_mantissa_1, b_mantissa_1, exp_sum_1, sign_1, special_flags_1} <= 0;
            {product_2, exp_sum_2, sign_2, special_flags_2} <= 0;
        end else begin
            case (stage)
                0: begin // Input and special case detection
                    // Extract components
                    a_sign_0 <= a[31];
                    b_sign_0 <= b[31];
                    a_exponent_0 <= a[30:23];
                    b_exponent_0 <= b[30:23];
                    a_mantissa_0 <= a[22:0];
                    b_mantissa_0 <= b[22:0];
                    
                    // Detect special cases
                    special_flags_0 <= {a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero)),
                                      (a_inf || b_inf) && ~special_flags_0[0],
                                      (a_zero || b_zero) && ~special_flags_0[0]};
                    
                    stage <= 1;
                end
                
                1: begin // Partial products and exponent sum
                    // Add implicit leading 1 if not denormal
                    a_mantissa_1 <= (|a_exponent_0) ? {1'b1, a_mantissa_0} : {1'b0, a_mantissa_0};
                    b_mantissa_1 <= (|b_exponent_0) ? {1'b1, b_mantissa_0} : {1'b0, b_mantissa_0};
                    
                    // Calculate partial products (4x6-bit chunks for better timing)
                    partial_prod_1[0] <= a_mantissa_1[5:0] * b_mantissa_1;
                    partial_prod_1[1] <= a_mantissa_1[11:6] * b_mantissa_1;
                    partial_prod_1[2] <= a_mantissa_1[17:12] * b_mantissa_1;
                    partial_prod_1[3] <= a_mantissa_1[23:18] * b_mantissa_1;
                    
                    // Exponent processing
                    exp_sum_1 <= {1'b0, a_exponent_0} + {1'b0, b_exponent_0} - 9'd127;
                    sign_1 <= a_sign_0 ^ b_sign_0;
                    special_flags_1 <= special_flags_0;
                    
                    stage <= 2;
                end
                
                2: begin // Final product sum
                    // Combine partial products with proper shifting
                    product_2 <= (partial_prod_1[3] << 18) + 
                                (partial_prod_1[2] << 12) + 
                                (partial_prod_1[1] << 6) + 
                                partial_prod_1[0];
                    
                    exp_sum_2 <= exp_sum_1;
                    sign_2 <= sign_1;
                    special_flags_2 <= special_flags_1;
                    
                    stage <= 3;
                end
                
                3: begin // Normalization, rounding and output
                    if (special_flags_2[0]) begin // NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                    end else if (special_flags_2[1]) begin // Inf
                        z <= {sign_2, 8'hFF, 23'b0};
                    end else if (special_flags_2[2]) begin // Zero
                        z <= {sign_2, 31'b0};
                    end else if (overflow) begin
                        z <= {sign_2, 8'hFF, 23'b0};
                    end else if (underflow) begin
                        z <= {sign_2, 31'b0};
                    end else begin
                        z <= {sign_2, adjusted_exp[7:0], rounded_mantissa};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule