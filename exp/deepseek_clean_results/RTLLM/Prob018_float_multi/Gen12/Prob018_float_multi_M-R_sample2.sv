module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1: Input extraction
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg [8:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    
    // Pipeline stage 2: Multiplication
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp_sum;
    reg stage2_sign;
    
    // Pipeline stage 3: Normalization
    reg [23:0] stage3_mantissa;
    reg [8:0] stage3_exponent;
    reg stage3_sign;
    reg stage3_guard, stage3_round, stage3_sticky;
    
    // Combinational extraction logic
    wire [23:0] a_mantissa = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_mantissa = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Combinational multiplication logic
    wire [47:0] product = stage1_a_mant * stage1_b_mant;
    wire [8:0] exp_sum = {1'b0, stage1_a_exp} + {1'b0, stage1_b_exp} - 9'd127;
    
    // Combinational normalization logic
    wire product_msb = stage2_product[47];
    wire [23:0] norm_mantissa = product_msb ? stage2_product[47:24] : stage2_product[46:23];
    wire [8:0] norm_exponent = product_msb ? (stage2_exp_sum + 1) : stage2_exp_sum;
    
    // Combinational rounding logic
    wire round_inc = stage3_guard && (stage3_round || stage3_sticky || stage3_mantissa[0]);
    wire [23:0] rounded_mantissa = round_inc ? stage3_mantissa + 1 : stage3_mantissa;
    wire [8:0] rounded_exponent = (&stage3_mantissa && round_inc) ? 
                                 stage3_exponent + 1 : stage3_exponent;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage3_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage3_sign, 31'b0};
    wire [31:0] normal_out = {stage3_sign, rounded_exponent[7:0], rounded_mantissa[22:0]};
    
    // Pipeline stage 1: Input extraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a_mant <= 0;
            stage1_b_mant <= 0;
            stage1_a_exp <= 0;
            stage1_b_exp <= 0;
            stage1_a_sign <= 0;
            stage1_b_sign <= 0;
        end else begin
            stage1_a_mant <= a_mantissa;
            stage1_b_mant <= b_mantissa;
            stage1_a_exp <= a[30:23];
            stage1_b_exp <= b[30:23];
            stage1_a_sign <= a[31];
            stage1_b_sign <= b[31];
        end
    end
    
    // Pipeline stage 2: Multiplication
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_product <= 0;
            stage2_exp_sum <= 0;
            stage2_sign <= 0;
        end else begin
            stage2_product <= product;
            stage2_exp_sum <= exp_sum;
            stage2_sign <= stage1_a_sign ^ stage1_b_sign;
        end
    end
    
    // Pipeline stage 3: Normalization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage3_mantissa <= 0;
            stage3_exponent <= 0;
            stage3_sign <= 0;
            stage3_guard <= 0;
            stage3_round <= 0;
            stage3_sticky <= 0;
        end else begin
            stage3_mantissa <= norm_mantissa;
            stage3_exponent <= norm_exponent;
            stage3_sign <= stage2_sign;
            stage3_guard <= stage2_product[22];
            stage3_round <= stage2_product[21];
            stage3_sticky <= |stage2_product[20:0];
        end
    end
    
    // Output stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (a_nan || b_nan) begin
                z <= nan_out;
            end
            else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                z <= nan_out;
            end
            else if (a_inf || b_inf) begin
                z <= inf_out;
            end
            else if (a_zero || b_zero) begin
                z <= zero_out;
            end
            else if (rounded_exponent[8] || &rounded_exponent[7:0]) begin // Overflow
                z <= inf_out;
            end
            else if (rounded_exponent == 0) begin // Underflow
                z <= zero_out;
            end
            else begin
                z <= normal_out;
            end
        end
    end

endmodule