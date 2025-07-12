module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg stage1_valid, stage2_valid;
    
    // Input decomposition
    wire a_sign = a_reg[31];
    wire b_sign = b_reg[31];
    wire [7:0] a_exp = a_reg[30:23];
    wire [7:0] b_exp = b_reg[30:23];
    wire [23:0] a_man = |a_exp ? {1'b1, a_reg[22:0]} : {1'b0, a_reg[22:0]};
    wire [23:0] b_man = |b_exp ? {1'b1, b_reg[22:0]} : {1'b0, b_reg[22:0]};

    // Special cases detection
    wire a_is_nan = (a_exp == 8'hFF) & (|a_reg[22:0]);
    wire b_is_nan = (b_exp == 8'hFF) & (|b_reg[22:0]);
    wire a_is_inf = (a_exp == 8'hFF) & (~|a_reg[22:0]);
    wire b_is_inf = (b_exp == 8'hFF) & (~|b_reg[22:0]);
    wire a_is_zero = (~|a_exp) & (~|a_reg[22:0]);
    wire b_is_zero = (~|b_exp) & (~|b_reg[22:0]);
    
    wire special_case = a_is_nan | b_is_nan | a_is_inf | b_is_inf | a_is_zero | b_is_zero;
    wire result_nan = a_is_nan | b_is_nan | (a_is_inf & b_is_zero) | (a_is_zero & b_is_inf);
    wire result_inf = (a_is_inf | b_is_inf) & ~result_nan;
    wire result_zero = a_is_zero | b_is_zero;

    // Multiplication core (pipelined)
    reg [47:0] product;
    reg [8:0] exp_sum;  // 9-bit to handle overflow
    reg sign_reg;
    
    // Rounding bits
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky_bit = |product[20:0];
    wire round_up = guard_bit & (round_bit | sticky_bit | product[23]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            stage1_valid <= 0;
            stage2_valid <= 0;
            z <= 0;
        end else begin
            // Stage 1: Register inputs and detect special cases
            a_reg <= a;
            b_reg <= b;
            stage1_valid <= 1;
            
            // Stage 2: Perform multiplication and exponent calculation
            if (stage1_valid && !special_case) begin
                product <= a_man * b_man;
                exp_sum <= {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
                sign_reg <= a_sign ^ b_sign;
            end
            stage2_valid <= stage1_valid;
            
            // Stage 3: Normalize, round, and output
            if (stage2_valid) begin
                if (special_case) begin
                    if (result_nan) z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Canonical NaN
                    else if (result_inf) z <= {sign_reg, 8'hFF, 23'b0};
                    else if (result_zero) z <= {sign_reg, 31'b0};
                end else begin
                    // Normalize and round
                    if (product[47]) begin
                        exp_sum <= exp_sum + 1;
                        product <= product << 1;
                    end
                    
                    // Apply rounding
                    if (round_up) begin
                        product[46:23] <= product[46:23] + 1;
                        // Handle mantissa overflow
                        if (&product[46:23]) begin
                            exp_sum <= exp_sum + 1;
                            product[46:23] <= 24'h800000;
                        end
                    end
                    
                    // Check for exponent overflow/underflow
                    if (exp_sum[8] || &exp_sum[7:0]) begin // Underflow or overflow
                        z <= {sign_reg, 8'hFF, 23'b0}; // Infinity
                    end else if (~|exp_sum[7:0]) begin // Underflow
                        z <= {sign_reg, 31'b0}; // Zero
                    end else begin
                        z <= {sign_reg, exp_sum[7:0], product[45:23]};
                    end
                end
            end
        end
    end

endmodule