module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Extract fields
    wire a_sign  = a[31];
    wire b_sign  = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detections
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);
    wire a_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);
    wire a_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with hidden bit (0 if denormals)
    wire [23:0] a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Sign of product
    wire product_sign = a_sign ^ b_sign;

    // Exponent sum adjusted
    wire [9:0] exp_sum = (a_exp == 0 ? 1 : a_exp) + (b_exp == 0 ? 1 : b_exp) - EXP_BIAS;

    // 24x24 bit mantissa multiplication (48 bits)
    wire [47:0] mant_product = a_mant * b_mant;

    // Normalization: if top bit of product is 1, shift right 1 and add 1 to exponent
    wire normalization_shift = mant_product[47];
    wire [47:0] norm_product = normalization_shift ? (mant_product >> 1) : mant_product;
    wire [9:0] norm_exp = normalization_shift ? (exp_sum + 1) : exp_sum;

    // Extract mantissa (23 bits), and rounding bits
    wire [22:0] mantissa = norm_product[46:24];
    wire guard_bit = norm_product[23];
    wire round_bit = norm_product[22];
    wire sticky_bit = |norm_product[21:0];

    // Round to nearest even
    wire round_up = guard_bit && (round_bit || sticky_bit || mantissa[0]);
    wire [23:0] mantissa_rounded = round_up ? ( {1'b0, mantissa} + 1 ) : {1'b0, mantissa};

    // Adjust exponent if rounding overflow
    wire rounding_overflow = mantissa_rounded[23];
    wire [9:0] final_exp = rounding_overflow ? (norm_exp + 1) : norm_exp;
    wire [22:0] final_mantissa = rounding_overflow ? mantissa_rounded[22:0] : mantissa_rounded[22:0];

    // Special case outputs
    wire nan_out_inf_zero = (a_inf && b_zero) || (b_inf && a_zero); // Invalid operation -> NaN

    reg [31:0] result;

    always @(*) begin
        // Default
        result = 32'd0;

        // Priority:
        // NaN input => quiet NaN
        if (a_nan || b_nan) begin
            result = {1'b0, 8'hFF, 1'b1, 22'd0};
        end
        // Inf * zero => NaN
        else if (nan_out_inf_zero) begin
            result = {1'b0, 8'hFF, 1'b1, 22'd0};
        end
        // Inf * finite (non-zero) => Inf
        else if (a_inf || b_inf) begin
            result = {product_sign, 8'hFF, 23'd0};
        end
        // Zero * anything (except Inf handled above) => Zero
        else if (a_zero || b_zero) begin
            result = {product_sign, 31'd0};
        end
        else begin
            // Check overflow (exp >= 255)
            if (final_exp[9:8] != 2'b00 || final_exp[7:0] >= 8'hFF) begin
                // Overflow -> Inf
                result = {product_sign, 8'hFF, 23'd0};
            end
            // Underflow or zero exponent after rounding (flush to zero)
            else if (final_exp[7:0] == 8'd0) begin
                // Underflow flush to zero (no denormals)
                result = {product_sign, 31'd0};
            end
            else begin
                // Normal number
                result = {product_sign, final_exp[7:0], final_mantissa};
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            z <= 32'd0;
        else
            z <= result;
    end

endmodule