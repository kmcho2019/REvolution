module float_multi(
    input [31:0] a,
    input [31:0] b,
    output [31:0] z
);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_man = a[22:0];
    wire [22:0] b_man = b[22:0];

    // Special cases
    wire a_zero = (a_exp == 0) & (a_man == 0);
    wire b_zero = (b_exp == 0) & (b_man == 0);
    wire a_inf = (a_exp == 8'hFF) & (a_man == 0);
    wire b_inf = (b_exp == 8'hFF) & (b_man == 0);
    wire a_nan = (a_exp == 8'hFF) & (a_man != 0);
    wire b_nan = (b_exp == 8'hFF) & (b_man != 0);

    // Result sign
    wire z_sign = a_sign ^ b_sign;

    // Handle special cases with priority
    assign z = (a_nan | b_nan) ? {z_sign, 8'hFF, 1'b1, 22'b0} : // NaN
               ((a_inf & b_zero) | (b_inf & a_zero)) ? {z_sign, 8'hFF, 1'b1, 22'b0} : // NaN (0*inf)
               (a_inf | b_inf) ? {z_sign, 8'hFF, 23'b0} : // Inf
               (a_zero | b_zero) ? {z_sign, 31'b0} : // Zero
               // Normal case
               begin
                   // Add implicit bit and multiply
                   wire [23:0] a_mant = {|a_exp, a_man};
                   wire [23:0] b_mant = {|b_exp, b_man};
                   wire [47:0] product = a_mant * b_mant;

                   // Normalize (product is either 47 or 46 bits)
                   wire [22:0] mantissa = product[47] ? product[46:24] : product[45:23];
                   wire round = product[47] ? product[23] : product[22];
                   wire [7:0] exponent = (a_exp + b_exp - 127) + product[47];

                   // Check for overflow/underflow
                   if (exponent[7:0] >= 8'hFF) {z_sign, 8'hFF, 23'b0} // Overflow
                   else if (exponent[7:0] == 0) {z_sign, 31'b0} // Underflow
                   else {z_sign, exponent[7:0], mantissa + round}; // Normal result
               end

endmodule