module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Extract components
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    // Calculate intermediate values
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp};
    wire [9:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Multiply mantissas
    wire [47:0] product = a_man * b_man;
    
    // Normalization
    wire product_msb = product[47];
    wire [47:0] normalized = product_msb ? product >> 1 : product;
    wire [9:0] final_exp_pre = product_msb ? exp_biased + 10'd1 : exp_biased;
    
    // Rounding bits
    wire guard = normalized[22];
    wire round = normalized[21];
    wire sticky = |normalized[20:0];
    wire round_up = guard && (round || sticky || normalized[23]);
    
    // Apply rounding
    wire [47:0] rounded = round_up ? normalized[47:23] + 25'd1 : normalized[47:23];
    wire carry = rounded[24];
    wire [22:0] final_mantissa = carry ? rounded[23:1] : rounded[22:0];
    wire [9:0] final_exp = carry ? final_exp_pre + 10'd1 : final_exp_pre;
    
    // Overflow/underflow detection
    wire overflow = (final_exp > 10'd254) || (exp_biased > 10'd254);
    wire underflow = (final_exp[9] || (final_exp == 0)) || 
                   (exp_biased[9] || (exp_biased == 0));

    always @(*) begin
        if (any_nan) begin
            z = {1'b0, 8'hFF, 23'h400000}; // qNaN
        end else if (inf_times_zero) begin
            z = {1'b0, 8'hFF, 23'h400000}; // qNaN
        end else if (a_is_inf || b_is_inf) begin
            z = {sign_result, 8'hFF, 23'h0}; // Inf
        end else if (a_is_zero || b_is_zero) begin
            z = {sign_result, 31'h0}; // Zero
        end else if (overflow) begin
            z = {sign_result, 8'hFF, 23'h0}; // Inf
        end else if (underflow) begin
            z = {sign_result, 31'h0}; // Zero
        end else begin
            z = {sign_result, final_exp[7:0], final_mantissa};
        end
    end

endmodule