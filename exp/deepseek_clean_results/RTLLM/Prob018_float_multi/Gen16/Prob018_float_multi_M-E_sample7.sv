module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg sign_reg;
    reg [7:0] exp_sum_reg;
    reg [47:0] product_reg;
    reg special_case_reg;
    reg [1:0] special_code_reg; // 00:normal, 01:zero, 10:inf, 11:nan

    // Input stage (stage 0)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

    // Early special case detection
    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]);
    wire is_zero = (a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]);
    wire inf_zero = ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));
    
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127;
    wire exp_overflow = (exp_sum > 8'hFD) || (&a_exp && &b_exp);
    wire exp_underflow = (exp_sum < 8'h02) || (a_exp == 0) || (b_exp == 0);

    // Multiply stage (stage 1)
    wire [47:0] product = a_man * b_man;
    
    // Normalize/Round stage (stage 2)
    wire norm_bit = product_reg[47];
    wire [7:0] final_exp = norm_bit ? exp_sum_reg + 1 : exp_sum_reg;
    wire [22:0] final_man = norm_bit ? product_reg[46:24] : product_reg[45:23];
    wire round_bit = norm_bit ? product_reg[23] : product_reg[22];
    wire sticky_bit = norm_bit ? |product_reg[22:0] : |product_reg[21:0];
    wire round_up = round_bit & (final_man[0] | sticky_bit);
    wire [22:0] rounded_man = final_man + round_up;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            a_reg <= 0;
            b_reg <= 0;
            sign_reg <= 0;
            exp_sum_reg <= 0;
            product_reg <= 0;
            special_case_reg <= 0;
            special_code_reg <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Input stage
                    a_reg <= a;
                    b_reg <= b;
                    sign_reg <= a_sign ^ b_sign;
                    exp_sum_reg <= exp_sum;
                    special_case_reg <= is_nan || is_inf || is_zero || inf_zero || exp_overflow || exp_underflow;
                    
                    // Encode special cases
                    if (is_nan || inf_zero) begin
                        special_code_reg <= 2'b11; // NaN
                    end else if (is_inf || exp_overflow) begin
                        special_code_reg <= 2'b10; // Inf
                    end else if (is_zero || exp_underflow) begin
                        special_code_reg <= 2'b01; // Zero
                    end else begin
                        special_code_reg <= 2'b00; // Normal
                    end
                    
                    stage <= 1;
                end
                
                1: begin // Multiply stage
                    product_reg <= product;
                    stage <= 2;
                end
                
                2: begin // Normalize/Round stage
                    if (special_case_reg) begin
                        case (special_code_reg)
                            2'b11: z <= {sign_reg, 8'hFF, 1'b1, 22'b0}; // NaN
                            2'b10: z <= {sign_reg, 8'hFF, 23'b0}; // Inf
                            2'b01: z <= {sign_reg, 31'b0}; // Zero
                            default: z <= 0;
                        endcase
                    end else begin
                        z <= {sign_reg, final_exp, rounded_man};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule