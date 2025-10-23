module float_multi(
    input [31:0] a,
    input [31:0] b,
    output [31:0] z
);

    // Sign calculation
    wire z_sign = a[31] ^ b[31];
    
    // Exponent and mantissa extraction
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_mant = (|a_exp) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_mant = (|b_exp) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Special cases
    wire a_nan = (a_exp == 8'hFF) && (|a[22:0]);
    wire b_nan = (b_exp == 8'hFF) && (|b[22:0]);
    wire a_inf = (a_exp == 8'hFF) && !(|a[22:0]);
    wire b_inf = (b_exp == 8'hFF) && !(|b[22:0]);
    wire a_zero = (a_exp == 0) && !(|a[22:0]);
    wire b_zero = (b_exp == 0) && !(|b[22:0]);
    
    // Multiplication
    wire [47:0] product = a_mant * b_mant;
    wire norm_bit = product[47];
    wire [22:0] z_mant = norm_bit ? product[46:24] : product[45:23];
    
    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp};
    wire [8:0] z_exp = exp_sum - 9'd127 + {8'b0, norm_bit};
    
    // Output selection
    assign z = (a_nan | b_nan) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
               ((a_inf & b_zero) | (b_inf & a_zero)) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // 0*inf
               (a_inf | b_inf) ? {z_sign, 8'hFF, 23'b0} : // inf
               (a_zero | b_zero) ? {z_sign, 31'b0} : // 0
               (z_exp[8] | (&z_exp[7:0])) ? {z_sign, 8'hFF, 23'b0} : // overflow
               {z_sign, z_exp[7:0], z_mant}; // normal case

endmodule