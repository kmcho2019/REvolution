module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_DECODE = 0;
    localparam S_EXPONENT = 1;
    localparam S_MULTIPLY = 2;
    localparam S_NORM_ROUND = 3;

    reg [1:0] stage;

    // Pipeline registers
    reg [31:0] a_reg, b_reg;
    reg a_sign_pipe[0:3], b_sign_pipe[0:3];
    reg is_special_pipe[0:3];
    reg [7:0] exp_sum_pipe[0:2];
    reg [23:0] a_mant_pipe[0:2], b_mant_pipe[0:2];
    reg [47:0] product_pipe;

    // Special case detection (first stage)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire is_special = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Special case results
    wire sign_result = a[31] ^ b[31];
    wire [31:0] special_result = 
        (a_nan | b_nan) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // Quiet NaN
        ((a_inf | b_inf) & (a_zero | b_zero)) ? {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN if 0*inf
        (a_inf | b_inf) ? {sign_result, 8'hFF, 23'b0} : // Infinity
        {sign_result, 31'b0}; // Zero

    // Normal path computations
    wire [7:0] a_exp = a_reg[30:23];
    wire [7:0] b_exp = b_reg[30:23];
    wire [23:0] a_mant = (|a_exp) ? {1'b1, a_reg[22:0]} : {1'b0, a_reg[22:0]};
    wire [23:0] b_mant = (|b_exp) ? {1'b1, b_reg[22:0]} : {1'b0, b_reg[22:0]};
    
    // Exponent processing (second stage)
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    wire exp_overflow = exp_sum[8] | &exp_sum[7:0];
    wire exp_underflow = (exp_sum < 9'd126);

    // Multiplication (third stage)
    wire [23:0] upper_a = a_mant_pipe[1][23:12];
    wire [11:0] lower_a = a_mant_pipe[1][11:0];
    wire [23:0] upper_b = b_mant_pipe[1][23:12];
    wire [11:0] lower_b = b_mant_pipe[1][11:0];
    
    wire [35:0] upper_prod = upper_a * upper_b;
    wire [35:0] cross_prod1 = upper_a * lower_b;
    wire [35:0] cross_prod2 = lower_a * upper_b;
    wire [23:0] lower_prod = lower_a * lower_b;

    // Normalization and rounding (fourth stage)
    wire [47:0] full_product = product_pipe;
    wire product_msb = full_product[47];
    wire [23:0] norm_mantissa = product_msb ? full_product[47:24] : full_product[46:23];
    wire [8:0] adj_exp = product_msb ? (exp_sum_pipe[2] + 1) : exp_sum_pipe[2];
    
    wire guard_bit = full_product[22];
    wire round_bit = full_product[21];
    wire sticky = |full_product[20:0];
    wire round_inc = guard_bit & (round_bit | sticky | norm_mantissa[0]);
    
    wire [23:0] rounded_mant = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [8:0] final_exp = (rounded_mant[23] & product_msb) ? adj_exp + 1 : adj_exp;
    
    wire [31:0] normal_result = 
        exp_overflow ? {sign_result_pipe[3], 8'hFF, 23'b0} :
        exp_underflow ? {sign_result_pipe[3], 31'b0} :
        {sign_result_pipe[3], final_exp[7:0], rounded_mant[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= S_DECODE;
            z <= 0;
            // Reset pipeline registers
            for (int i=0; i<4; i=i+1) begin
                a_sign_pipe[i] <= 0;
                b_sign_pipe[i] <= 0;
                is_special_pipe[i] <= 0;
            end
            for (int i=0; i<3; i=i+1) begin
                exp_sum_pipe[i] <= 0;
                a_mant_pipe[i] <= 0;
                b_mant_pipe[i] <= 0;
            end
            product_pipe <= 0;
        end else begin
            case (stage)
                S_DECODE: begin
                    a_reg <= a;
                    b_reg <= b;
                    a_sign_pipe[0] <= a[31];
                    b_sign_pipe[0] <= b[31];
                    is_special_pipe[0] <= is_special;
                    stage <= S_EXPONENT;
                end
                
                S_EXPONENT: begin
                    // Propagate pipeline
                    a_sign_pipe[1] <= a_sign_pipe[0];
                    b_sign_pipe[1] <= b_sign_pipe[0];
                    is_special_pipe[1] <= is_special_pipe[0];
                    
                    // Exponent processing
                    exp_sum_pipe[0] <= exp_sum;
                    a_mant_pipe[0] <= a_mant;
                    b_mant_pipe[0] <= b_mant;
                    stage <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    // Propagate pipeline
                    a_sign_pipe[2] <= a_sign_pipe[1];
                    b_sign_pipe[2] <= b_sign_pipe[1];
                    is_special_pipe[2] <= is_special_pipe[1];
                    exp_sum_pipe[1] <= exp_sum_pipe[0];
                    a_mant_pipe[1] <= a_mant_pipe[0];
                    b_mant_pipe[1] <= b_mant_pipe[0];
                    
                    // Multiplier computation
                    product_pipe <= upper_prod + 
                                   ({cross_prod1, 12'b0} >> 12) + 
                                   ({cross_prod2, 12'b0} >> 12) + 
                                   ({24'b0, lower_prod} >> 24);
                    stage <= S_NORM_ROUND;
                end
                
                S_NORM_ROUND: begin
                    // Propagate pipeline
                    a_sign_pipe[3] <= a_sign_pipe[2];
                    b_sign_pipe[3] <= b_sign_pipe[2];
                    is_special_pipe[3] <= is_special_pipe[2];
                    exp_sum_pipe[2] <= exp_sum_pipe[1];
                    a_mant_pipe[2] <= a_mant_pipe[1];
                    b_mant_pipe[2] <= b_mant_pipe[1];
                    
                    // Output selection
                    z <= is_special_pipe[2] ? special_result : normal_result;
                    stage <= S_DECODE;
                end
            endcase
        end
    end

endmodule