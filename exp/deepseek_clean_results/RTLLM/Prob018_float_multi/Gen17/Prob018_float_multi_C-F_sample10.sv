module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot pipeline stages
    localparam INPUT_STAGE  = 3'b001;
    localparam MULT_STAGE   = 3'b010;
    localparam NORM_STAGE   = 3'b100;
    
    reg [2:0] stage;
    reg [31:0] a_reg, b_reg;
    reg sign_reg;
    reg [7:0] exp_sum_reg;
    reg [47:0] product_reg;
    reg special_case;
    reg [1:0] special_code; // 00:normal, 01:zero, 10:inf, 11:nan
    
    // Split multiplier signals
    wire [15:0] a_hi = a_reg[22:7];
    wire [15:0] a_lo = {9'b0, a_reg[6:0]};
    wire [15:0] b_hi = b_reg[22:7];
    wire [15:0] b_lo = {9'b0, b_reg[6:0]};
    reg [31:0] pp_hi, pp_mid1, pp_mid2, pp_lo;
    reg [47:0] product_sum;

    // Input stage logic
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Special case detection (gated with stage)
    wire is_nan = (stage == INPUT_STAGE) && 
                 ((a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]));
    wire is_inf = (stage == INPUT_STAGE) && 
                 ((a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]));
    wire is_zero = (stage == INPUT_STAGE) && 
                 ((a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]));
    wire inf_zero = (stage == INPUT_STAGE) && 
                 ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));
    
    // Exponent calculation
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127;
    wire exp_overflow = (exp_sum > 8'hFD) || (&a_exp && &b_exp);
    wire exp_underflow = (exp_sum < 8'h02) || (a_exp == 0) || (b_exp == 0);

    // Normalization/Round stage logic
    wire norm_bit = product_reg[47];
    wire [7:0] final_exp = norm_bit ? exp_sum_reg + 1 : exp_sum_reg;
    wire [22:0] final_man = norm_bit ? product_reg[46:24] : product_reg[45:23];
    wire round_bit = norm_bit ? product_reg[23] : product_reg[22];
    wire sticky_bit = norm_bit ? |product_reg[22:0] : |product_reg[21:0];
    wire round_up = round_bit & (final_man[0] | sticky_bit);
    wire [22:0] rounded_man = final_man + round_up;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= INPUT_STAGE;
            a_reg <= 0;
            b_reg <= 0;
            sign_reg <= 0;
            exp_sum_reg <= 0;
            product_reg <= 0;
            special_case <= 0;
            special_code <= 0;
            z <= 0;
        end else begin
            case (stage)
                INPUT_STAGE: begin
                    // Register inputs
                    a_reg <= a;
                    b_reg <= b;
                    sign_reg <= a_sign ^ b_sign;
                    exp_sum_reg <= exp_sum;
                    
                    // Special case encoding
                    special_case <= is_nan || is_inf || is_zero || inf_zero || exp_overflow || exp_underflow;
                    if (is_nan || inf_zero) begin
                        special_code <= 2'b11; // NaN
                    end else if (is_inf || exp_overflow) begin
                        special_code <= 2'b10; // Inf
                    end else if (is_zero || exp_underflow) begin
                        special_code <= 2'b01; // Zero
                    end else begin
                        special_code <= 2'b00; // Normal
                    end
                    
                    // Calculate partial products
                    pp_hi <= a_hi * b_hi;
                    pp_mid1 <= a_hi * b_lo;
                    pp_mid2 <= a_lo * b_hi;
                    pp_lo <= a_lo * b_lo;
                    
                    stage <= MULT_STAGE;
                end
                
                MULT_STAGE: begin
                    // Combine partial products with carry-save addition
                    product_sum <= (pp_hi << 14) + (pp_mid1 << 7) + (pp_mid2 << 7) + pp_lo;
                    product_reg <= product_sum;
                    
                    stage <= NORM_STAGE;
                end
                
                NORM_STAGE: begin
                    if (special_case) begin
                        case (special_code)
                            2'b11: z <= {sign_reg, 8'hFF, 1'b1, 22'b0}; // NaN
                            2'b10: z <= {sign_reg, 8'hFF, 23'b0}; // Inf
                            2'b01: z <= {sign_reg, 31'b0}; // Zero
                            default: z <= 0;
                        endcase
                    end else begin
                        z <= {sign_reg, final_exp, rounded_man};
                    end
                    
                    stage <= INPUT_STAGE;
                end
            endcase
        end
    end

endmodule