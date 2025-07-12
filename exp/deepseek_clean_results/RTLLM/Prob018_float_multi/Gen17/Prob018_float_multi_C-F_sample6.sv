module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam STAGE_INPUT = 3'b001;
    localparam STAGE_MULT  = 3'b010;
    localparam STAGE_NORM  = 3'b100;
    
    reg [2:0] state;
    
    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg sign_reg;
    reg [8:0] exp_sum_reg;
    reg [47:0] product_reg;
    reg special_case_reg;
    reg [1:0] special_code_reg; // 00:normal, 01:zero, 10:inf, 11:nan
    
    // Input processing
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Early special case detection (gated by state)
    wire is_nan = (state == STAGE_INPUT) && 
                 ((a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]));
    wire is_inf = (state == STAGE_INPUT) && 
                 ((a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]));
    wire is_zero = (state == STAGE_INPUT) && 
                  ((a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]));
    wire inf_zero = (state == STAGE_INPUT) && 
                   ((a_exp == 8'hFF && b_exp == 0) || (b_exp == 8'hFF && a_exp == 0));
    
    // Split multiplier with carry-save optimization
    wire [11:0] a_hi = a_man[23:12];
    wire [11:0] a_lo = a_man[11:0];
    wire [11:0] b_hi = b_man[23:12];
    wire [11:0] b_lo = b_man[11:0];
    
    wire [23:0] hi_hi = a_hi * b_hi;
    wire [23:0] hi_lo = a_hi * b_lo;
    wire [23:0] lo_hi = a_lo * b_hi;
    wire [23:0] lo_lo = a_lo * b_lo;
    wire [47:0] product = (hi_hi << 24) + (hi_lo << 12) + (lo_hi << 12) + lo_lo;
    
    // Normalization and rounding
    wire norm_bit = product_reg[47];
    wire [8:0] final_exp = norm_bit ? exp_sum_reg + 1 : exp_sum_reg;
    wire [22:0] final_man = norm_bit ? product_reg[46:24] : product_reg[45:23];
    wire guard_bit = norm_bit ? product_reg[23] : product_reg[22];
    wire sticky_bit = norm_bit ? |product_reg[22:0] : |product_reg[21:0];
    wire round_up = guard_bit & (final_man[0] | sticky_bit);
    wire [22:0] rounded_man = final_man + round_up;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STAGE_INPUT;
            a_reg <= 0;
            b_reg <= 0;
            sign_reg <= 0;
            exp_sum_reg <= 0;
            product_reg <= 0;
            special_case_reg <= 0;
            special_code_reg <= 0;
            z <= 0;
        end else begin
            case (state)
                STAGE_INPUT: begin
                    a_reg <= a;
                    b_reg <= b;
                    sign_reg <= a_sign ^ b_sign;
                    exp_sum_reg <= {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
                    special_case_reg <= is_nan || is_inf || is_zero || inf_zero;
                    
                    // Encode special cases
                    if (is_nan || inf_zero) begin
                        special_code_reg <= 2'b11; // NaN
                    end else if (is_inf) begin
                        special_code_reg <= 2'b10; // Inf
                    end else if (is_zero) begin
                        special_code_reg <= 2'b01; // Zero
                    end else begin
                        special_code_reg <= 2'b00; // Normal
                    end
                    
                    state <= STAGE_MULT;
                end
                
                STAGE_MULT: begin
                    product_reg <= product;
                    state <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    if (special_case_reg) begin
                        case (special_code_reg)
                            2'b11: z <= {sign_reg, 8'hFF, 1'b1, 22'b0}; // NaN
                            2'b10: z <= {sign_reg, 8'hFF, 23'b0}; // Inf
                            2'b01: z <= {sign_reg, 31'b0}; // Zero
                            default: z <= 0;
                        endcase
                    end else begin
                        // Check for overflow/underflow
                        if (final_exp[8] || (final_exp[7:0] == 8'hFF)) begin
                            z <= {sign_reg, 8'hFF, 23'b0}; // Overflow
                        end else if (final_exp[7:0] == 0) begin
                            z <= {sign_reg, 31'b0}; // Underflow
                        end else begin
                            z <= {sign_reg, final_exp[7:0], rounded_man};
                        end
                    end
                    state <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule