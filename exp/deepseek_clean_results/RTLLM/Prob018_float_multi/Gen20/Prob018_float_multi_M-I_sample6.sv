module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline control
    reg [1:0] stage;
    wire stage0_active = (stage == 0);
    wire stage1_active = (stage == 1);
    wire stage2_active = (stage == 2);
    wire stage3_active = (stage == 3);
    
    // Clock gating signals
    wire clk_stage1 = clk & stage0_active;
    wire clk_stage2 = clk & stage1_active;
    wire clk_stage3 = clk & stage2_active;
    
    // Special case encoding
    localparam [1:0] NORMAL = 2'b00,
                     INF    = 2'b01,
                     ZERO   = 2'b10,
                     NAN    = 2'b11;
    
    // Stage 0 registers (clock gated)
    reg [22:0] a_mantissa_0, b_mantissa_0;
    reg [7:0] a_exponent_0, b_exponent_0;
    reg a_sign_0, b_sign_0;
    reg [1:0] special_case_0;
    
    // Stage 1 registers (clock gated)
    reg [23:0] a_mantissa_1, b_mantissa_1;
    reg [7:0] exp_sum_1;
    reg sign_1;
    reg [1:0] special_case_1;
    reg [71:0] partial_products_1; // 3x24-bit partial products
    
    // Stage 2 registers (clock gated)
    reg [46:0] product_2; // 47-bit product (23x24)
    reg [7:0] exp_sum_2;
    reg sign_2;
    reg [1:0] special_case_2;
    
    // Stage 3 wires
    wire [4:0] lzd = product_2[46] ? 5'd0 : 
                    product_2[45] ? 5'd1 :
                    // ... (full LZD logic up to 5'd23)
                    product_2[23] ? 5'd23 : 5'd24;
    
    wire [46:0] shifted_product = product_2 << lzd;
    wire [7:0] adjusted_exp = exp_sum_2 - lzd;
    
    // Rounding logic
    wire guard_bit = shifted_product[22];
    wire round_bit = shifted_product[21];
    wire sticky = |shifted_product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || shifted_product[23]);
    wire [22:0] rounded_mantissa = shifted_product[46:24] + round_inc;
    
    // Overflow/underflow
    wire overflow = &adjusted_exp || (adjusted_exp >= 254 && round_inc);
    wire underflow = (adjusted_exp == 0) || (adjusted_exp[7] && !adjusted_exp[6]);
    
    // Output selection
    wire [31:0] normal_out = {sign_2, 
                             overflow ? 8'hFF : underflow ? 8'h00 : adjusted_exp,
                             overflow ? 23'b0 : underflow ? 23'b0 : rounded_mantissa[22:0]};
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            // Clear pipeline registers
            {a_mantissa_0, b_mantissa_0, a_exponent_0, b_exponent_0} <= 0;
            {a_sign_0, b_sign_0, special_case_0} <= 0;
            {a_mantissa_1, b_mantissa_1, exp_sum_1, sign_1, special_case_1, partial_products_1} <= 0;
            {product_2, exp_sum_2, sign_2, special_case_2} <= 0;
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
                    
                    // Detect and encode special cases
                    if (a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero))) begin
                        special_case_0 <= NAN;
                    end else if (a_inf || b_inf) begin
                        special_case_0 <= INF;
                    end else if (a_zero || b_zero) begin
                        special_case_0 <= ZERO;
                    end else begin
                        special_case_0 <= NORMAL;
                    end
                    
                    stage <= 1;
                end
                
                1: begin // Partial products and exponent pre-processing
                    // Prepare mantissas (add implicit bit)
                    a_mantissa_1 <= (|a_exponent_0) ? {1'b1, a_mantissa_0} : {1'b0, a_mantissa_0};
                    b_mantissa_1 <= (|b_exponent_0) ? {1'b1, b_mantissa_0} : {1'b0, b_mantissa_0};
                    
                    // Compute exponent sum (with bias adjustment)
                    exp_sum_1 <= a_exponent_0 + b_exponent_0 - 8'd127;
                    sign_1 <= a_sign_0 ^ b_sign_0;
                    special_case_1 <= special_case_0;
                    
                    // Generate partial products (Wallace tree first stage)
                    partial_products_1[23:0] <= b_mantissa_1 & {24{a_mantissa_1[0]}};
                    partial_products_1[47:24] <= (b_mantissa_1 & {24{a_mantissa_1[1]}}) << 1;
                    partial_products_1[71:48] <= (b_mantissa_1 & {24{a_mantissa_1[2]}}) << 2;
                    
                    stage <= 2;
                end
                
                2: begin // Final multiplication stage
                    // Wallace tree reduction (simplified for readability)
                    // In practice would use carry-save adders here
                    product_2 <= partial_products_1[23:0] + 
                                partial_products_1[47:24] + 
                                partial_products_1[71:48] + 
                                (a_mantissa_1[23:3] * b_mantissa_1);
                    
                    exp_sum_2 <= exp_sum_1;
                    sign_2 <= sign_1;
                    special_case_2 <= special_case_1;
                    
                    stage <= 3;
                end
                
                3: begin // Normalization, rounding and output
                    case (special_case_2)
                        NAN: z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Canonical NaN
                        INF: z <= {sign_2, 8'hFF, 23'b0};
                        ZERO: z <= {sign_2, 31'b0};
                        default: z <= normal_out;
                    endcase
                    stage <= 0;
                end
            endcase
        end
    end

endmodule