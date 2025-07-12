module float_multi(
    input [31:0] a,
    input [31:0] b,
    output [31:0] z
);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (|a_exp) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (|b_exp) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    // Special cases detection (priority encoded)
    wire a_is_nan = &a_exp && |a[22:0];
    wire b_is_nan = &b_exp && |b[22:0];
    wire a_is_inf = &a_exp && ~|a[22:0];
    wire b_is_inf = &b_exp && ~|b[22:0];
    wire a_is_zero = ~|a_exp && ~|a[22:0];
    wire b_is_zero = ~|b_exp && ~|b[22:0];

    // Special case results
    wire is_nan = a_is_nan || b_is_nan;
    wire is_inf = (a_is_inf || b_is_inf) && !is_nan;
    wire is_zero = (a_is_zero || b_is_zero) && !is_nan && !is_inf;
    wire inf_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Normal number processing
    wire [47:0] product = a_man * b_man;
    wire norm_bit = product[47];
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127 + norm_bit;
    wire exp_overflow = &exp_sum;
    wire exp_underflow = ~|exp_sum;
    wire [22:0] final_man = norm_bit ? product[46:24] : product[45:23];

    // Final result selection
    assign z = is_nan || inf_zero ? 32'h7FC00000 :       // NaN
               is_inf             ? {a_sign ^ b_sign, 8'hFF, 23'b0} :  // Infinity
               is_zero            ? {a_sign ^ b_sign, 31'b0} :         // Zero
               exp_overflow || exp_underflow ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Overflow/Underflow
               {a_sign ^ b_sign, exp_sum, final_man};  // Normal case

endmodule