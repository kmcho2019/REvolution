module float_multi(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_mant = {|a_exp, a[22:0]};
    wire [23:0] b_mant = {|b_exp, b[22:0]};

    // Special cases
    wire a_zero = (a_exp == 0) && (a[22:0] == 0);
    wire b_zero = (b_exp == 0) && (b[22:0] == 0);
    wire a_inf = (a_exp == 8'hFF) && (a[22:0] == 0);
    wire b_inf = (b_exp == 8'hFF) && (b[22:0] == 0);
    wire a_nan = (a_exp == 8'hFF) && (a[22:0] != 0);
    wire b_nan = (b_exp == 8'hFF) && (b[22:0] != 0);

    // Multiply mantissas (48-bit result)
    wire [47:0] product = a_mant * b_mant;

    // Calculate exponent (sum - bias + normalization)
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    wire norm_shift = product[47];
    wire [7:0] final_exp = exp_sum[8] ? 8'h00 : (exp_sum + norm_shift);

    // Final mantissa (truncated)
    wire [22:0] final_mant = norm_shift ? product[46:24] : product[45:23];

    // Output selection
    always @* begin
        if (a_nan || b_nan) begin
            z = 32'h7FC00000; // NaN
        end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
            z = 32'h7FC00000; // 0*inf = NaN
        end else if (a_inf || b_inf) begin
            z = {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
        end else if (a_zero || b_zero) begin
            z = {a_sign ^ b_sign, 31'b0}; // Zero
        end else if (final_exp == 8'hFF) begin // Overflow
            z = {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
        end else begin
            z = {a_sign ^ b_sign, final_exp, final_mant};
        end
    end

endmodule