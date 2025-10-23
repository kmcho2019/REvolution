module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Input fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases inputs
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Prepare mantissas: add implicit leading 1 for normals, zero for denormals
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Multiply mantissas (24x24=48 bits)
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;

    // Exponent sum: 
    // If exponent == 0 => denormal => treat as exponent 1 for bias correction
    wire [9:0] a_exp_adj = (a_exp == 8'd0) ? 10'd1 : {2'd0,a_exp};
    wire [9:0] b_exp_adj = (b_exp == 8'd0) ? 10'd1 : {2'd0,b_exp};
    wire [9:0] exp_sum = a_exp_adj + b_exp_adj - EXP_BIAS;

    // Calculate sign
    wire sign = a_sign ^ b_sign;

    // Normalize product:
    // If mantissa_product[47] == 1, normalized, exponent incremented by 1
    // Else shift left by 1 (use bits [46:23]) and exponent unchanged
    wire mantissa_msb = mantissa_product[47];
    wire [23:0] mantissa_norm = mantissa_msb ? mantissa_product[47:24] : mantissa_product[46:23];
    wire [9:0] exp_norm = mantissa_msb ? (exp_sum + 10'd1) : exp_sum;

    // Rounding bits:
    // guard: bit after mantissa (bit 23 or 22 depending on normalization)
    // round: next bit after guard
    // sticky: OR of all remaining bits after round bit

    wire guard_bit = mantissa_msb ? mantissa_product[23] : mantissa_product[22];
    wire round_bit = mantissa_msb ? mantissa_product[22] : mantissa_product[21];
    wire sticky_bits = mantissa_msb ? |mantissa_product[21:0] : |mantissa_product[20:0];

    // Round to nearest even
    // increment mantissa if guard=1 and (round=1 or sticky=1 or LSB=1)
    wire round_increment = guard_bit && (round_bit || sticky_bits || mantissa_norm[0]);
    wire [24:0] mantissa_rounded = {1'b0,mantissa_norm} + round_increment;

    // After rounding, check overflow in mantissa (bit 24)
    wire mantissa_overflow = mantissa_rounded[24];

    wire [7:0] exp_rounded;
    wire [22:0] frac_rounded;

    assign exp_rounded = mantissa_overflow ? (exp_norm[7:0] + 8'd1) : exp_norm[7:0];
    assign frac_rounded = mantissa_overflow ? mantissa_rounded[24:2] : mantissa_rounded[22:0];

    // Handle special cases in output
    // Priority:
    // 1) NaN if any operand NaN or inf*0
    // 2) Inf if inf*nonzero or nonzero*inf
    // 3) Zero if zero*non-inf or non-inf*zero
    // 4) Otherwise normal result with overflow and underflow handling

    wire invalid = a_is_nan || b_is_nan || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
    wire result_is_inf = ((a_is_inf && !b_is_zero && !b_is_nan) || (b_is_inf && !a_is_zero && !a_is_nan)) && !invalid;
    wire result_is_zero = ((a_is_zero && !b_is_inf && !b_is_nan) || (b_is_zero && !a_is_inf && !a_is_nan)) && !invalid;

    // Overflow -> infinity
    wire overflow = (exp_rounded >= 8'hFF);

    // Underflow -> zero (flush)
    wire underflow = (exp_rounded <= 0);

    // Compose final output combinationally
    reg [31:0] result;

    always @* begin
        if (invalid) begin
            // Quiet NaN: exponent all ones, mantissa MSB=1
            result = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (result_is_inf || overflow) begin
            // Infinity
            result = {sign, 8'hFF, 23'd0};
        end else if (result_is_zero || underflow) begin
            // Zero
            result = {sign, 31'd0};
        end else begin
            // Normal number
            result = {sign, exp_rounded, frac_rounded};
        end
    end

    // Register output synchronously
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= result;
        end
    end

endmodule