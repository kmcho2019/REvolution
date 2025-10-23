module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage registers
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg sign_reg;
    reg [8:0] exp_sum_reg;
    reg a_zero_reg, b_zero_reg;
    reg a_inf_reg, b_inf_reg;
    reg a_nan_reg, b_nan_reg;
    
    // Multiplier signals
    wire [23:0] a_mant = (a_reg[30:23] != 0) ? {1'b1, a_reg[22:0]} : {1'b0, a_reg[22:0]};
    wire [23:0] b_mant = (b_reg[30:23] != 0) ? {1'b1, b_reg[22:0]} : {1'b0, b_reg[22:0]};
    
    // Carry-save multiplier partial products
    reg [23:0] pp [23:0];
    reg [47:0] sum, carry;
    
    // Normalization signals
    wire [47:0] product = sum + (carry << 1);
    wire norm_shift = product[47];
    wire [46:0] shifted_product = norm_shift ? product[46:0] : {product[45:0], 1'b0};
    
    // Rounding signals
    wire guard = shifted_product[22];
    wire round = shifted_product[21];
    wire sticky = |shifted_product[20:0];
    wire round_up = guard & (round | sticky | shifted_product[23]);
    wire [23:0] rounded_mant = shifted_product[46:23] + round_up;
    
    // Exponent calculation
    wire [8:0] exp_adj = exp_sum_reg - 9'd127 + norm_shift;
    wire exp_overflow = (exp_adj[8] | (&exp_adj[7:0]));
    wire exp_underflow = (exp_adj[8] & !exp_adj[7]);
    
    // Special cases
    wire special_case = a_nan_reg | b_nan_reg | a_inf_reg | b_inf_reg | a_zero_reg | b_zero_reg;
    wire nan_case = a_nan_reg | b_nan_reg | (a_inf_reg & b_zero_reg) | (b_inf_reg & a_zero_reg);
    wire inf_case = (a_inf_reg | b_inf_reg) & !nan_case;
    wire zero_case = (a_zero_reg | b_zero_reg) & !nan_case;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 1: Decode and setup
                    a_reg <= a;
                    b_reg <= b;
                    sign_reg <= a[31] ^ b[31];
                    
                    // Special case detection
                    a_zero_reg <= (a[30:23] == 0) && (a[22:0] == 0);
                    b_zero_reg <= (b[30:23] == 0) && (b[22:0] == 0);
                    a_inf_reg <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf_reg <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    a_nan_reg <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_nan_reg <= (b[30:23] == 8'hFF) && (b[22:0] != 0);
                    
                    // Exponent sum
                    exp_sum_reg <= {1'b0, a[30:23]} + {1'b0, b[30:23]};
                    
                    // Generate partial products
                    for (integer i = 0; i < 24; i = i + 1) begin
                        pp[i] <= b_mant[i] ? a_mant : 24'b0;
                    end
                    
                    stage <= 1;
                end
                
                1: begin // Stage 2: Carry-save reduction
                    // First level of CSA reduction
                    for (integer i = 0; i < 12; i = i + 1) begin
                        {carry[2*i+1], sum[2*i]} = pp[2*i] + pp[2*i+1];
                        carry[2*i] = 1'b0;
                        sum[2*i+1] = pp[2*i+1][0];
                    end
                    
                    // Second level of CSA reduction
                    for (integer i = 0; i < 6; i = i + 1) begin
                        {carry[4*i+3], sum[4*i+2]} = sum[4*i:4*i+1] + carry[4*i:4*i+1];
                    end
                    
                    stage <= 2;
                end
                
                2: begin // Stage 3: Final addition and normalization
                    if (special_case) begin
                        if (nan_case) begin
                            z <= 32'h7FC00000;
                        end else if (inf_case) begin
                            z <= {sign_reg, 8'hFF, 23'b0};
                        end else if (zero_case) begin
                            z <= {sign_reg, 31'b0};
                        end
                    end else if (exp_overflow) begin
                        z <= {sign_reg, 8'hFF, 23'b0};
                    end else if (exp_underflow) begin
                        z <= {sign_reg, 31'b0};
                    end else begin
                        z <= {sign_reg, exp_adj[7:0], rounded_mant[22:0]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule