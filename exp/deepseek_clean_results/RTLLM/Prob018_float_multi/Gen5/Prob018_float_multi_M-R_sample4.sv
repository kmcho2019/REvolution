module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg [31:0] a_reg, b_reg;
    reg stage1_sign;
    reg [8:0] stage1_exp_sum;  // Extra bit for overflow detection
    reg [47:0] stage1_product;
    reg stage1_special;
    reg [31:0] stage1_special_result;

    // Pipeline stage 2 registers
    reg stage2_sign;
    reg [8:0] stage2_exp;
    reg [23:0] stage2_mantissa;
    reg stage2_special;
    reg [31:0] stage2_special_result;

    // Special case detection (combinational)
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Stage 1 calculations (combinational)
    wire sign = a[31] ^ b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = |a_exp ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = |b_exp ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    wire [8:0] exp_sum = a_exp + b_exp - 127;
    wire [47:0] product = a_man * b_man;

    // Special case result
    wire [31:0] special_result = 
        any_nan || inf_times_zero ? {1'b0, 8'hFF, 23'h400000} :  // qNaN
        a_is_inf || b_is_inf ? {sign, 8'hFF, 23'h0} :             // Inf
        {sign, 31'h0};                                            // Zero

    // Pipeline stage 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            stage1_sign <= 0;
            stage1_exp_sum <= 0;
            stage1_product <= 0;
            stage1_special <= 0;
            stage1_special_result <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            stage1_sign <= sign;
            stage1_exp_sum <= exp_sum;
            stage1_product <= product;
            stage1_special <= any_nan || a_is_inf || b_is_inf || a_is_zero || b_is_zero;
            stage1_special_result <= special_result;
        end
    end

    // Stage 2 calculations (combinational)
    wire product_msb = stage1_product[47];
    wire [47:0] normalized_product = product_msb ? stage1_product >> 1 : stage1_product;
    wire [8:0] normalized_exp = product_msb ? stage1_exp_sum + 1 : stage1_exp_sum;

    // Rounding logic
    wire guard = normalized_product[22];
    wire round = normalized_product[21];
    wire sticky = |normalized_product[20:0];
    wire round_up = guard && (round || sticky || normalized_product[23]);
    wire [47:0] rounded_product = round_up ? normalized_product + (1 << 23) : normalized_product;
    wire rounded_msb = rounded_product[47];
    wire [23:0] final_mantissa = rounded_msb ? rounded_product[46:23] : rounded_product[45:22];
    wire [8:0] final_exp = rounded_msb ? normalized_exp + 1 : normalized_exp;

    // Overflow/underflow detection
    wire overflow = final_exp[8] || (final_exp[7:0] == 8'hFF);
    wire underflow = final_exp[8];
    wire [31:0] normal_result = 
        overflow ? {stage1_sign, 8'hFF, 23'h0} :
        underflow ? {stage1_sign, 31'h0} :
        {stage1_sign, final_exp[7:0], final_mantissa[22:0]};

    // Pipeline stage 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
            stage2_sign <= 0;
            stage2_exp <= 0;
            stage2_mantissa <= 0;
            stage2_special <= 0;
            stage2_special_result <= 0;
        end else begin
            z <= stage1_special ? stage1_special_result : normal_result;
        end
    end

endmodule