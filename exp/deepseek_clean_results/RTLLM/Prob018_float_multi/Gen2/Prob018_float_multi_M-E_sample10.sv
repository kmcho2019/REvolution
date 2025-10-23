module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg special_case;
    reg [31:0] special_result;
    
    // Multiplier decomposition
    wire [11:0] a_hi = a_mantissa[23:12];
    wire [11:0] a_lo = a_mantissa[11:0];
    wire [11:0] b_hi = b_mantissa[23:12];
    wire [11:0] b_lo = b_mantissa[11:0];
    
    // Partial products
    reg [23:0] pp_hi_hi, pp_hi_lo, pp_lo_hi, pp_lo_lo;
    reg [47:0] product;
    
    // Normalization
    reg [47:0] normalized_product;
    reg [8:0] exp_sum;
    reg [7:0] final_exp;
    reg norm_shift;
    
    // Rounding
    reg [22:0] rounded_mantissa;
    reg round_up;
    
    // Special case detection (combinatorial)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire is_nan = a_nan || b_nan || (a_inf && b_zero) || (b_inf && a_zero);
    wire is_inf = (a_inf || b_inf) && !is_nan;
    wire is_zero = (a_zero || b_zero) && !is_nan;
    wire result_sign = a_sign ^ b_sign;
    
    always @(*) begin
        // Special case result
        if (is_nan)
            special_result = 32'h7FC00000;
        else if (is_inf)
            special_result = {result_sign, 8'hFF, 23'b0};
        else if (is_zero)
            special_result = {result_sign, 31'b0};
        else
            special_result = 32'h0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 0: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Calculate partial products
                    pp_hi_hi <= a_hi * b_hi;
                    pp_hi_lo <= a_hi * b_lo;
                    pp_lo_hi <= a_lo * b_hi;
                    pp_lo_lo <= a_lo * b_lo;
                    
                    // Pre-calculate exponent sum with bias adjustment
                    exp_sum <= {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
                    
                    // Check if we need to handle as special case
                    special_case <= is_nan || is_inf || is_zero;
                    
                    stage <= 1;
                end
                
                1: begin  // Stage 1: Product accumulation and early normalization
                    // Combine partial products with carry-save addition
                    product <= ({pp_hi_hi, 24'b0} + {12'b0, pp_hi_lo, 12'b0} + 
                                {12'b0, pp_lo_hi, 12'b0} + {24'b0, pp_lo_lo});
                    
                    // Early normalization decision
                    norm_shift <= product[47];
                    
                    // Adjust exponent based on normalization
                    if (product[47])
                        final_exp <= exp_sum[8] ? 8'hFF : (exp_sum[7:0] + 1);
                    else
                        final_exp <= exp_sum[8] ? 8'h00 : exp_sum[7:0];
                    
                    stage <= 2;
                end
                
                2: begin  // Stage 2: Final normalization and rounding
                    // Normalize product
                    normalized_product <= norm_shift ? product : {product[46:0], 1'b0};
                    
                    // First-stage rounding (simple cases)
                    if (normalized_product[22] && (|normalized_product[21:0])) begin
                        round_up <= 1;
                    end else begin
                        round_up <= 0;
                    end
                    
                    stage <= 3;
                end
                
                3: begin  // Stage 3: Final rounding and output
                    // Second-stage rounding (tie cases)
                    if (normalized_product[22] && normalized_product[21] && 
                        !(|normalized_product[20:0]) && normalized_product[23]) begin
                        round_up <= 1;
                    end
                    
                    // Apply rounding
                    rounded_mantissa <= normalized_product[46:24] + round_up;
                    
                    // Final output selection
                    if (special_case) begin
                        z <= special_result;
                    end else if (final_exp == 8'hFF) begin  // Overflow
                        z <= {result_sign, 8'hFF, 23'b0};
                    end else if (final_exp == 8'h00) begin  // Underflow
                        z <= {result_sign, 31'b0};
                    end else begin
                        z <= {result_sign, final_exp, rounded_mantissa[22:0]};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule