module float_multi (
    input [31:0] a,
    input [31:0] b,
    output [31:0] z
);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_man = (b_exp == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Special cases
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (a_exp == 8'hFF) & (a[22:0] == 0);
    wire b_inf = (b_exp == 8'hFF) & (b[22:0] == 0);
    wire a_nan = (a_exp == 8'hFF) & (a[22:0] != 0);
    wire b_nan = (b_exp == 8'hFF) & (b[22:0] != 0);
    wire result_nan = a_nan | b_nan | (a_zero & b_inf) | (a_inf & b_zero);
    wire result_inf = (a_inf | b_inf) & ~result_nan;
    wire result_zero = (a_zero | b_zero) & ~result_nan;

    // Multiply mantissas
    wire [47:0] product = a_man * b_man;

    // Calculate exponent
    wire [8:0] exp_sum = a_exp + b_exp - 127;

    // Normalize (assume product[47] is set for normalized inputs)
    wire [22:0] z_man = product[46:24]; // Truncate instead of round
    wire [7:0] z_exp = exp_sum[7:0] + product[47]; // Adjust exponent if overflow

    // Final result
    assign z = result_nan ? {1'b0, 8'hFF, 23'h7FFFFF} : // NaN
               result_inf ? {a_sign ^ b_sign, 8'hFF, 23'h0} : // Infinity
               result_zero ? {a_sign ^ b_sign, 31'h0} : // Zero
               {a_sign ^ b_sign, z_exp, z_man}; // Normal case

endmodule