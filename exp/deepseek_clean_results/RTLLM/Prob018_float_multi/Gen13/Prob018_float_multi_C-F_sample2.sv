module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    reg [1:0] stage;
    
    // Input processing
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    
    // Special cases
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Normal path
    reg [23:0] a_mant, b_mant; // 24-bit mantissa (1.frac)
    reg [9:0] exp_sum;         // Extended exponent sum
    reg sign_reg;
    
    // Partial products (16x16 + 8x8 + cross terms)
    reg [31:0] pp_hi;  // a[23:8] * b[23:8]
    reg [15:0] pp_lo;  // a[7:0] * b[7:0]
    reg [23:0] pp_hl;  // a[23:8] * b[7:0]
    reg [23:0] pp_lh;  // a[7:0] * b[23:8]
    
    // Product accumulation
    reg [47:0] product;
    
    // Normalization and rounding
    reg [22:0] final_mant;
    reg [7:0] final_exp;
    reg final_sign;
    reg guard, round, sticky;
    
    // Special case result
    wire [31:0] special_result = 
        (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
        (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
        {a_sign ^ b_sign, 31'b0}; // Zero

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];
                    
                    // Form mantissas (with implicit 1)
                    a_mant <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mant <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Calculate exponent sum
                    exp_sum <= {2'b0, a_exp} + {2'b0, b_exp} - 9'd127;
                    sign_reg <= a_sign ^ b_sign;
                    
                    stage <= special_case ? 2'd3 : 2'd1; // Skip to output if special case
                end
                
                1: begin // Stage 1: Partial products
                    // Split multiplication (16x16 + 8x8 + cross terms)
                    pp_hi <= a_mant[23:8] * b_mant[23:8];
                    pp_lo <= a_mant[7:0] * b_mant[7:0];
                    pp_hl <= a_mant[23:8] * b_mant[7:0];
                    pp_lh <= a_mant[7:0] * b_mant[23:8];
                    
                    stage <= stage + 1;
                end
                
                2: begin // Stage 2: Accumulation and normalization
                    // Combine partial products with proper alignment
                    product <= {pp_hi, 16'b0} + 
                              {8'b0, pp_hl, 8'b0} + 
                              {8'b0, pp_lh, 8'b0} + 
                              {16'b0, pp_lo};
                    
                    // Normalize
                    if (product[47]) begin // Product >= 2
                        final_mant <= product[46:24];
                        final_exp <= exp_sum[7:0] + 1;
                    end else begin
                        final_mant <= product[45:23];
                        final_exp <= exp_sum[7:0];
                    end
                    
                    // Extract rounding bits
                    guard <= product[22];
                    round <= product[21];
                    sticky <= |product[20:0];
                    
                    final_sign <= sign_reg;
                    stage <= stage + 1;
                end
                
                3: begin // Stage 3: Rounding and output
                    // Round to nearest even
                    if (guard && (round || sticky || final_mant[0])) begin
                        {final_exp, final_mant} <= {final_exp, final_mant} + 1;
                        if (&final_exp) begin // Overflow from rounding
                            final_exp <= 8'hFF;
                            final_mant <= 23'b0;
                        end
                    end
                    
                    // Handle special cases or normal output
                    if (special_case) begin
                        z <= special_result;
                    end else if (&final_exp) begin // Overflow
                        z <= {final_sign, 8'hFF, 23'b0};
                    end else if (final_exp == 0) begin // Underflow
                        z <= {final_sign, 31'b0};
                    end else begin
                        z <= {final_sign, final_exp, final_mant};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule