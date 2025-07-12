module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg stage1_valid;
    wire [31:0] a_use = stage1_valid ? a_reg : a;
    wire [31:0] b_use = stage1_valid ? b_reg : b;

    // Clock gating
    wire clk_en = ~rst && (~stage1_valid || (|a) || (|b));
    wire gated_clk;
    assign gated_clk = clk & clk_en;

    // Input decomposition
    wire a_sign = a_use[31];
    wire b_sign = b_use[31];
    wire [7:0] a_exp = a_use[30:23];
    wire [7:0] b_exp = b_use[30:23];
    wire [23:0] a_man = {|a_exp, a_use[22:0]};
    wire [23:0] b_man = {|b_exp, b_use[22:0]};

    // Special cases (optimized)
    wire a_is_nan = (a_exp == 8'hFF) & (|a_use[22:0]);
    wire b_is_nan = (b_exp == 8'hFF) & (|b_use[22:0]);
    wire a_is_inf = (a_exp == 8'hFF) & (~|a_use[22:0]);
    wire b_is_inf = (b_exp == 8'hFF) & (~|b_use[22:0]);
    wire a_is_zero = (a_exp == 0) & (~|a_use[22:0]);
    wire b_is_zero = (b_exp == 0) & (~|b_use[22:0]);
    
    wire is_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (b_is_inf & a_is_zero);
    wire is_inf = (a_is_inf | b_is_inf) & ~is_nan;
    wire is_zero = (a_is_zero | b_is_zero) & ~is_nan & ~is_inf;

    // Pipeline stage 1: Register inputs and detect special cases
    always @(posedge gated_clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            stage1_valid <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            stage1_valid <= 1;
        end
    end

    // Pipeline stage 2: Multiplication and normalization
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg sign_reg;
    reg special_case;
    reg [1:0] special_code; // 00:normal, 01:zero, 10:inf, 11:nan

    always @(posedge gated_clk) begin
        if (~stage1_valid) begin
            // Stage 1: Perform multiplication
            product <= a_man * b_man;
            exp_sum <= a_exp + b_exp;
            sign_reg <= a_sign ^ b_sign;
            
            // Special case encoding
            special_case <= is_nan | is_inf | is_zero;
            special_code <= {is_nan | is_inf, is_nan};
        end else begin
            // Stage 2: Normalization and rounding
            wire norm_bit = product[47];
            wire [47:0] shifted_product = norm_bit ? product : {product[46:0], 1'b0};
            
            // Round to nearest even
            wire round_bit = shifted_product[22];
            wire sticky_bit = |shifted_product[21:0];
            wire round_up = round_bit & (shifted_product[23] | sticky_bit);
            wire [23:0] rounded_man = shifted_product[46:23] + round_up;
            
            // Exponent adjustment
            wire [9:0] adjusted_exp = exp_sum + norm_bit - 10'd127 + rounded_man[23];
            wire [7:0] final_exp = adjusted_exp[8] ? 8'd0 : (adjusted_exp[9] ? 8'hFF : adjusted_exp[7:0]);
            wire [22:0] final_man = rounded_man[22:0];
            
            // Output selection
            if (special_case) begin
                case (special_code)
                    2'b00: z <= {sign_reg, 31'b0}; // zero
                    2'b01: z <= {sign_reg, 8'hFF, 23'b0}; // inf
                    default: z <= 32'h7FC00000; // nan
                endcase
            end else if (adjusted_exp[9] & ~adjusted_exp[8]) begin // overflow
                z <= {sign_reg, 8'hFF, 23'b0};
            end else if (~|final_exp & ~|final_man) begin // underflow
                z <= {sign_reg, 31'b0};
            end else begin
                z <= {sign_reg, final_exp, final_man};
            end
        end
    end

endmodule