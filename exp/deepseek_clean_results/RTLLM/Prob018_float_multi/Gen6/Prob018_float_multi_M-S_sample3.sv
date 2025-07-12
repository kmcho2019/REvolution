module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];
    
    // Combined special cases
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire any_inf = a_is_inf || b_is_inf;
    wire any_zero = a_is_zero || b_is_zero;

    always @(*) begin
        if (any_nan || inf_times_zero) begin
            z = {1'b0, 8'hFF, 23'h400000}; // qNaN
        end else if (any_inf) begin
            z = {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
        end else if (any_zero) begin
            z = {a[31] ^ b[31], 31'h0}; // Zero
        end else begin
            // Extract components
            wire a_sign = a[31];
            wire b_sign = b[31];
            wire [7:0] a_exp = a[30:23];
            wire [7:0] b_exp = b[30:23];
            wire [23:0] a_man = |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            wire [23:0] b_man = |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Calculate exponent
            wire [8:0] exp_sum = a_exp + b_exp;
            wire [7:0] z_exp = exp_sum - 8'd127;
            
            // Multiply mantissas (48-bit result)
            wire [47:0] product = a_man * b_man;
            
            // Normalize
            wire [47:0] norm_product;
            wire [7:0] norm_exp;
            if (product[47]) begin
                norm_product = product >> 1;
                norm_exp = z_exp + 1;
            end else begin
                norm_product = product;
                norm_exp = z_exp;
            end
            
            // Rounding
            wire guard = norm_product[22];
            wire round = norm_product[21];
            wire sticky = |norm_product[20:0];
            wire [23:0] rounded_mantissa = norm_product[46:23] + (guard && (round || sticky));
            
            // Final adjustments
            wire [7:0] final_exp;
            wire [22:0] final_mantissa;
            if (rounded_mantissa[23]) begin // Rounding caused overflow
                final_exp = norm_exp + 1;
                final_mantissa = rounded_mantissa[23:1];
            end else begin
                final_exp = norm_exp;
                final_mantissa = rounded_mantissa[22:0];
            end
            
            // Handle overflow/underflow
            if (exp_sum < 127 || final_exp == 0) begin // Underflow
                z = {a_sign ^ b_sign, 31'h0};
            end else if (exp_sum > 381 || final_exp[7] || &final_exp) begin // Overflow
                z = {a_sign ^ b_sign, 8'hFF, 23'h0};
            end else begin
                z = {a_sign ^ b_sign, final_exp, final_mantissa};
            end
        end
    end

endmodule