module float_multi(
    input clk,
    input rst,
    input en,        // Added enable for clock gating
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg stage1_valid;
    reg a_sign_reg, b_sign_reg;
    reg [7:0] a_exp_reg, b_exp_reg;
    reg [23:0] a_man_reg, b_man_reg;
    reg special_case_reg;
    reg is_nan_reg, is_inf_reg, is_zero_reg, inf_zero_reg;

    // Pipeline stage 2 registers
    reg stage2_valid;
    reg sign_reg;
    reg [7:0] exp_sum_reg;
    reg [47:0] product_reg;
    reg norm_bit_reg;
    reg special_case_stage2_reg;
    reg is_nan_stage2, is_inf_stage2, is_zero_stage2, inf_zero_stage2;

    // Combinational logic - Stage 1
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    // Special case detection (optimized)
    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]);
    wire is_zero = (a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]);
    wire inf_zero = ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));
    wire special_case = is_nan | is_inf | is_zero | inf_zero;

    // Pipeline stage 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_valid <= 0;
        end else if (en) begin
            stage1_valid <= 1;
            a_sign_reg <= a_sign;
            b_sign_reg <= b_sign;
            a_exp_reg <= a_exp;
            b_exp_reg <= b_exp;
            a_man_reg <= a_man;
            b_man_reg <= b_man;
            special_case_reg <= special_case;
            is_nan_reg <= is_nan;
            is_inf_reg <= is_inf;
            is_zero_reg <= is_zero;
            inf_zero_reg <= inf_zero;
        end else begin
            stage1_valid <= 0;
        end
    end

    // Pipeline stage 2 - Multiplication core
    wire [7:0] exp_sum = a_exp_reg + b_exp_reg - 8'd127;
    wire [47:0] product = a_man_reg * b_man_reg;
    wire norm_bit = product[47];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_valid <= 0;
            z <= 0;
        end else if (stage1_valid) begin
            stage2_valid <= 1;
            sign_reg <= a_sign_reg ^ b_sign_reg;
            exp_sum_reg <= exp_sum;
            product_reg <= product;
            norm_bit_reg <= norm_bit;
            special_case_stage2_reg <= special_case_reg;
            is_nan_stage2 <= is_nan_reg;
            is_inf_stage2 <= is_inf_reg;
            is_zero_stage2 <= is_zero_reg;
            inf_zero_stage2 <= inf_zero_reg;
        end else begin
            stage2_valid <= 0;
        end
    end

    // Final output calculation
    wire [7:0] final_exp = norm_bit_reg ? exp_sum_reg + 1 : exp_sum_reg;
    wire [22:0] final_man = norm_bit_reg ? product_reg[46:24] : product_reg[45:23];
    wire overflow = &final_exp;
    wire underflow = (final_exp == 0);

    always @(*) begin
        if (stage2_valid) begin
            if (is_nan_stage2 || inf_zero_stage2) begin
                z = 32'h7FC00000; // NaN
            end else if (is_inf_stage2) begin
                z = {sign_reg, 8'hFF, 23'b0}; // Infinity
            end else if (is_zero_stage2) begin
                z = {sign_reg, 31'b0}; // Zero
            end else if (overflow || underflow) begin
                z = {sign_reg, 8'hFF, 23'b0}; // Infinity
            end else begin
                z = {sign_reg, final_exp, final_man};
            end
        end else begin
            z = 0;
        end
    end

endmodule