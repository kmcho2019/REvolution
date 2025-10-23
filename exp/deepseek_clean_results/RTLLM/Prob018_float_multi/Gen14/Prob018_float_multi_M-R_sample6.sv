module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Continuous special case detection
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    wire [31:0] special_result = 
        (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
        (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
        {a_sign ^ b_sign, 31'b0}; // Zero

    // Normal path processing - Stage 1
    wire [15:0] a_upper = (a_exp == 0) ? {1'b0, a_frac[22:8]} : {1'b1, a_frac[22:8]};
    wire [15:0] b_upper = (b_exp == 0) ? {1'b0, b_frac[22:8]} : {1'b1, b_frac[22:8]};
    wire [7:0] a_lower = a_frac[7:0];
    wire [7:0] b_lower = b_frac[7:0];
    wire [8:0] exp_sum = a_exp + b_exp - 127; // 9-bit to handle overflow
    wire sign_reg = a_sign ^ b_sign;

    // Partial products - Stage 2
    wire [31:0] pp_uu = a_upper * b_upper;
    wire [23:0] pp_ul = a_upper * b_lower;
    wire [23:0] pp_lu = a_lower * b_upper;
    wire [15:0] pp_ll = a_lower * b_lower;

    // Product accumulation
    wire [47:0] product = {pp_uu, 16'b0} + 
                         {8'b0, pp_ul, 8'b0} + 
                         {8'b0, pp_lu, 8'b0} + 
                         {16'b0, pp_ll};

    // Normalization and rounding - Stage 3
    wire norm_shift = product[47];
    wire [46:0] shifted_product = norm_shift ? product[46:0] : {product[45:0], 1'b0};
    wire [22:0] product_mantissa = shifted_product[46:24];
    wire round_bit = shifted_product[23];
    wire sticky_bit = |shifted_product[22:0];
    wire [22:0] rounded_mantissa = product_mantissa + (round_bit & (product_mantissa[0] | sticky_bit));
    wire [8:0] final_exponent = exp_sum + norm_shift + (rounded_mantissa[22] & ~norm_shift);

    // Output formatting
    wire [31:0] normal_result = 
        (final_exponent[8] | (final_exponent == 0)) ? {sign_reg, 31'b0} : // Underflow
        (&final_exponent[7:0]) ? {sign_reg, 8'hFF, 23'b0} : // Overflow
        {sign_reg, final_exponent[7:0], rounded_mantissa[21:0]};

    // Output register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            z <= special_case ? special_result : normal_result;
        end
    end

endmodule