module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special cases
    wire a_is_nan = &a_exp && |a_frac;
    wire b_is_nan = &b_exp && |b_frac;
    wire a_is_inf = &a_exp && ~|a_frac;
    wire b_is_inf = &b_exp && ~|b_frac;
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];

    wire z_is_nan = a_is_nan || b_is_nan || (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire z_is_inf = (a_is_inf || b_is_inf) && !z_is_nan;
    wire z_is_zero = a_is_zero || b_is_zero;

    // Main calculation
    wire [23:0] a_mant = |a_exp ? {1'b1, a_frac} : {1'b0, a_frac};
    wire [23:0] b_mant = |b_exp ? {1'b1, b_frac} : {1'b0, b_frac};
    wire [47:0] product = a_mant * b_mant;
    wire [9:0] exp_sum = {2'b0, a_exp} + {2'b0, b_exp} - 10'd127;

    // Normalization
    wire norm_shift = product[47];
    wire [46:0] norm_product = norm_shift ? product[46:0] : product[45:0] << 1;
    wire [9:0] norm_exp = exp_sum + norm_shift;

    // Rounding (guard and round bits only)
    wire guard = norm_product[22];
    wire round = norm_product[21];
    wire [23:0] frac_rounded = norm_product[46:23] + (guard & (round | norm_product[23]));

    // Final assembly
    wire overflow = (norm_exp >= 10'd255) || (frac_rounded[23] && (norm_exp == 10'd254));
    wire underflow = (norm_exp <= 0);

    always @* begin
        if (z_is_nan) begin
            z = {1'b0, 8'hFF, 23'h400000}; // Quiet NaN
        end else if (z_is_inf) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'h0}; // Infinity
        end else if (z_is_zero) begin
            z = {a_sign ^ b_sign, 31'h0}; // Zero
        end else if (overflow) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'h0}; // Overflow to Inf
        end else if (underflow) begin
            z = {a_sign ^ b_sign, 31'h0}; // Underflow to Zero
        end else begin
            z = {a_sign ^ b_sign, norm_exp[7:0], frac_rounded[22:0]};
        end
    end

endmodule