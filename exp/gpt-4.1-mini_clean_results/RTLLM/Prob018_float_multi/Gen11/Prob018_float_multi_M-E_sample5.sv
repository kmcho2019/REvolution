module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Extract fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Detect special cases
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Sign of output
    wire z_sign = a_sign ^ b_sign;

    // Prepare mantissas with implicit leading 1 for normalized, 0 for denormals
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Exponent as 10-bit to avoid overflow
    wire [9:0] a_exp_ext = (a_exp == 8'd0) ? 10'd1 : {2'b00, a_exp};
    wire [9:0] b_exp_ext = (b_exp == 8'd0) ? 10'd1 : {2'b00, b_exp};

    // Mantissa product 24x24 -> 48 bits
    wire [47:0] product = a_mantissa * b_mantissa;

    // Exponent sum with bias subtraction
    wire [9:0] exp_sum = a_exp_ext + b_exp_ext - EXP_BIAS;

    // Normalization: Check if top product bit set
    wire product_msb = product[47];

    wire [23:0] mantissa_norm = product_msb ? product[47:24] : product[46:23];
    wire [9:0] exponent_norm = product_msb ? (exp_sum + 10'd1) : exp_sum;

    // Guard, round, sticky bits
    wire guard_bit = product_msb ? product[23] : product[22];
    wire round_bit = product_msb ? product[22] : product[21];
    wire sticky_bit = product_msb ? |product[21:0] : |product[20:0];

    // Round to nearest even increment
    wire round_increment = guard_bit && (round_bit || sticky_bit || mantissa_norm[0]);

    wire [24:0] mantissa_rounded_pre = {1'b0, mantissa_norm} + round_increment;
    // mantissa_rounded_pre is 25 bits to hold possible overflow

    // Final mantissa and exponent adjustment
    wire mantissa_overflow = mantissa_rounded_pre[24];

    wire [7:0] final_exp = mantissa_overflow ? (exponent_norm[7:0] + 8'd1) : exponent_norm[7:0];
    wire [22:0] final_frac = mantissa_overflow ? mantissa_rounded_pre[24:2] : mantissa_rounded_pre[22:0];

    // Handle special cases
    wire any_nan = a_nan || b_nan;
    wire inf_zero = (a_inf && b_zero) || (b_inf && a_zero);

    wire any_inf = a_inf || b_inf;
    wire any_zero = a_zero || b_zero;

    // Output logic combinational
    reg [31:0] z_next;

    always @* begin
        if (any_nan) begin
            // Quiet NaN (MSB of mantissa set)
            z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (inf_zero) begin
            // Inf * 0 = NaN
            z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (any_inf) begin
            // Inf * non-zero = Inf
            z_next = {z_sign, 8'hFF, 23'd0};
        end else if (any_zero) begin
            // Zero * anything = zero
            z_next = {z_sign, 31'd0};
        end else begin
            // Normal number handling overflow and underflow
            if (final_exp >= 8'hFF) begin
                // Overflow to infinity
                z_next = {z_sign, 8'hFF, 23'd0};
            end else if (final_exp <= 0) begin
                // Underflow flush to zero (no subnormal handling here)
                z_next = {z_sign, 31'd0};
            end else begin
                z_next = {z_sign, final_exp, final_frac};
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            z <= z_next;
        end
    end
endmodule