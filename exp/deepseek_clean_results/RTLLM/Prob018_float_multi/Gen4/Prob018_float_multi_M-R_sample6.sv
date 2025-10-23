module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detection
    wire a_is_nan = &a_exp && |a_frac;
    wire b_is_nan = &b_exp && |b_frac;
    wire a_is_inf = &a_exp && ~|a_frac;
    wire b_is_inf = &b_exp && ~|b_frac;
    wire a_is_zero = ~|a_exp && ~|a_frac;
    wire b_is_zero = ~|b_exp && ~|b_frac;
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Mantissa handling with implicit bit
    wire [23:0] a_man = |a_exp ? {1'b1, a_frac} : {1'b0, a_frac};
    wire [23:0] b_man = |b_exp ? {1'b1, b_frac} : {1'b0, b_frac};

    // Product calculation
    wire [47:0] product = a_man * b_man;
    wire product_msb = product[47];

    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp};
    wire [8:0] exp_biased = exp_sum - 9'd127;

    // Normalization
    wire [47:0] norm_product = product_msb ? product : product << 1;
    wire [8:0] norm_exp = product_msb ? exp_biased + 1 : exp_biased;

    // Rounding
    wire guard = norm_product[22];
    wire round = norm_product[21];
    wire sticky = |norm_product[20:0];
    wire round_up = guard & (round | sticky | norm_product[23]);

    wire [22:0] final_frac = round_up ? 
                           (norm_product[46:24] + 1) : 
                           norm_product[46:24];
    wire [8:0] final_exp = round_up && &norm_product[46:24] ? 
                          norm_exp + 1 : norm_exp;

    // Overflow/underflow detection
    wire overflow = final_exp[8] || &final_exp[7:0];
    wire underflow = final_exp[8] && ~final_exp[7];

    // Result assembly
    wire [31:0] result;
    assign result = any_nan ? {1'b0, 8'hFF, 23'h400000} : // qNaN
                  inf_times_zero ? {1'b0, 8'hFF, 23'h400000} : // qNaN
                  a_is_inf || b_is_inf ? {a_sign ^ b_sign, 8'hFF, 23'h0} : // Inf
                  a_is_zero || b_is_zero ? {a_sign ^ b_sign, 31'h0} : // Zero
                  overflow ? {a_sign ^ b_sign, 8'hFF, 23'h0} : // Overflow to Inf
                  underflow ? {a_sign ^ b_sign, 31'h0} : // Underflow to Zero
                  {a_sign ^ b_sign, final_exp[7:0], final_frac}; // Normal case

    // Register output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            z <= result;
        end
    end

endmodule