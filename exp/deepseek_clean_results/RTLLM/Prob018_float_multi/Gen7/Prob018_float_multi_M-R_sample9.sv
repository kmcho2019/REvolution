module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Constants
    localparam BIAS = 127;
    localparam EXP_WIDTH = 8;
    localparam MANT_WIDTH = 23;
    
    // Pipeline registers
    reg [31:0] stage1_a, stage1_b;
    reg [31:0] stage2_a, stage2_b;
    reg [31:0] stage3_a, stage3_b;
    reg [31:0] stage4_a, stage4_b;
    
    // Special case detection
    wire a_zero = (stage1_a[30:0] == 0);
    wire b_zero = (stage1_b[30:0] == 0);
    wire a_inf = (&stage1_a[30:23]) && (stage1_a[22:0] == 0);
    wire b_inf = (&stage1_b[30:23]) && (stage1_b[22:0] == 0);
    wire a_nan = (&stage1_a[30:23]) && (|stage1_a[22:0]);
    wire b_nan = (&stage1_b[30:23]) && (|stage1_b[22:0]);
    
    // Stage 1: Input registration
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a <= 0;
            stage1_b <= 0;
        end else begin
            stage1_a <= a;
            stage1_b <= b;
        end
    end
    
    // Stage 2: Component extraction
    wire a_sign = stage1_a[31];
    wire b_sign = stage1_b[31];
    wire [EXP_WIDTH:0] a_exp = {1'b0, stage1_a[30:23]};
    wire [EXP_WIDTH:0] b_exp = {1'b0, stage1_b[30:23]};
    wire [MANT_WIDTH:0] a_mant = (|stage1_a[30:23]) ? {1'b1, stage1_a[22:0]} : {1'b0, stage1_a[22:0]};
    wire [MANT_WIDTH:0] b_mant = (|stage1_b[30:23]) ? {1'b1, stage1_b[22:0]} : {1'b0, stage1_b[22:0]};
    
    always @(posedge clk) begin
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
    end
    
    // Stage 3: Multiplication
    wire [2*MANT_WIDTH+1:0] product = a_mant * b_mant;
    wire [EXP_WIDTH+1:0] exp_sum = a_exp + b_exp;
    wire [EXP_WIDTH+1:0] exp_biased = exp_sum - BIAS;
    wire sign_result = a_sign ^ b_sign;
    
    always @(posedge clk) begin
        stage3_a <= stage2_a;
        stage3_b <= stage2_b;
    end
    
    // Stage 4: Normalization
    wire product_msb = product[2*MANT_WIDTH+1];
    wire [MANT_WIDTH:0] norm_mant = product_msb ? product[2*MANT_WIDTH+1:MANT_WIDTH+1] : 
                                               product[2*MANT_WIDTH:MANT_WIDTH];
    wire [EXP_WIDTH+1:0] norm_exp = product_msb ? (exp_biased + 1) : exp_biased;
    wire guard_bit = product[MANT_WIDTH-1];
    wire round_bit = product[MANT_WIDTH-2];
    wire sticky_bit = |product[MANT_WIDTH-3:0];
    
    always @(posedge clk) begin
        stage4_a <= stage3_a;
        stage4_b <= stage3_b;
    end
    
    // Stage 5: Rounding and output
    wire round_inc = guard_bit && (round_bit || sticky_bit || norm_mant[0]);
    wire [MANT_WIDTH:0] final_mant = norm_mant + round_inc;
    wire [EXP_WIDTH+1:0] final_exp = (final_mant[MANT_WIDTH+1]) ? (norm_exp + 1) : norm_exp;
    
    // Output selection
    wire is_nan = a_nan || b_nan || (a_inf && b_zero) || (a_zero && b_inf);
    wire is_inf = (a_inf || b_inf) && !is_nan;
    wire is_zero = (a_zero || b_zero) && !is_nan;
    wire overflow = final_exp[EXP_WIDTH+1] || (&final_exp[EXP_WIDTH:0]);
    wire underflow = ~final_exp[EXP_WIDTH+1] && (final_exp == 0);
    
    wire [31:0] result = 
        is_nan ? {1'b0, 8'hFF, 1'b1, 22'b0} :
        is_inf ? {sign_result, 8'hFF, 23'b0} :
        is_zero ? {sign_result, 31'b0} :
        overflow ? {sign_result, 8'hFF, 23'b0} :
        underflow ? {sign_result, 31'b0} :
        {sign_result, final_exp[EXP_WIDTH-1:0], final_mant[MANT_WIDTH-1:0]};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            z <= result;
        end
    end

endmodule