module float_multi (
    input              clk,
    input              rst,         // synchronous active high reset
    input      [31:0]  a,
    input      [31:0]  b,
    output reg [31:0]  z
);
    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;
    localparam EXP_ZERO = 8'd0;

    // Extract fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases
    wire a_is_zero = (a_exp == EXP_ZERO) && (a_frac == 0);
    wire b_is_zero = (b_exp == EXP_ZERO) && (b_frac == 0);
    wire a_is_inf  = (a_exp == EXP_INF_NAN) && (a_frac == 0);
    wire b_is_inf  = (b_exp == EXP_INF_NAN) && (b_frac == 0);
    wire a_is_nan  = (a_exp == EXP_INF_NAN) && (a_frac != 0);
    wire b_is_nan  = (b_exp == EXP_INF_NAN) && (b_frac != 0);

    // Compute sign of product
    wire prod_sign = a_sign ^ b_sign;

    // Prepare mantissas (with implicit leading 1 for normals, 0 for denormals)
    wire [23:0] a_mant = (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Multiply mantissas: 24x24 -> 48 bits
    wire [47:0] product = a_mant * b_mant;

    // Calculate exponent sum with bias adjustment
    // For zero exponent (denormals), treat as exponent=1 (per IEEE 754)
    wire [9:0] a_exp_10 = (a_exp == 0) ? 10'd1 : {2'd0, a_exp};
    wire [9:0] b_exp_10 = (b_exp == 0) ? 10'd1 : {2'd0, b_exp};
    wire [9:0] exp_sum = a_exp_10 + b_exp_10 - EXP_BIAS;

    // Normalize product:
    // If product[47] == 1, number is >=2, shift right by 1 and add 1 to exponent
    wire prod_msb = product[47];
    wire [47:0] norm_prod = prod_msb ? (product >> 1) : product;
    wire [9:0] norm_exp = prod_msb ? (exp_sum + 10'd1) : exp_sum;

    // Extract mantissa (top 24 bits)
    wire [23:0] mantissa = norm_prod[46:23];

    // Rounding bits
    wire guard = norm_prod[22];
    wire roundb = norm_prod[21];
    wire sticky = |norm_prod[20:0];

    // Round to nearest even
    wire round_increment = guard && (roundb || sticky || mantissa[0]);
    wire [24:0] mantissa_rounded = {1'b0, mantissa} + (round_increment ? 25'd1 : 25'd0);

    wire mantissa_carry = mantissa_rounded[24];
    wire [23:0] mantissa_final = mantissa_carry ? mantissa_rounded[24:1] : mantissa_rounded[23:0];
    wire [9:0] exponent_final = mantissa_carry ? (norm_exp + 10'd1) : norm_exp;

    // Detect overflow and underflow
    wire overflow = (exponent_final >= 10'd255);
    wire underflow = (exponent_final <= 10'd0);

    // Final exponent (8 bits), saturate or zero
    wire [7:0] exponent_out = overflow ? 8'hFF :
                             underflow ? 8'd0 :
                             exponent_final[7:0];

    // Construct NaN (quiet), infinity, zero results
    wire [31:0] qnan = {1'b0, 8'hFF, 1'b1, 22'd0};
    wire [31:0] inf = {prod_sign, 8'hFF, 23'd0};
    wire [31:0] zero = {prod_sign, 31'd0};
    wire [31:0] normal = {prod_sign, exponent_out, mantissa_final[22:0]};

    // Special cases resolution
    reg [31:0] result;
    always @(*) begin
        if (a_is_nan) result = a;        // Propagate input NaN
        else if (b_is_nan) result = b;
        else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) result = qnan; // inf*zero = NaN
        else if (a_is_inf || b_is_inf) result = inf;
        else if (a_is_zero || b_is_zero) result = zero;
        else if (overflow) result = inf;
        else if (underflow) result = zero;
        else result = normal;
    end

    // Output register
    always @(posedge clk) begin
        if (rst) z <= 32'd0;
        else z <= result;
    end
endmodule