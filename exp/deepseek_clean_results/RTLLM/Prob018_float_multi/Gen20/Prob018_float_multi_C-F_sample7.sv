module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 0: Input extraction and special case detection
    reg [23:0] stage0_a_mant, stage0_b_mant;
    reg [7:0] stage0_a_exp, stage0_b_exp;
    reg stage0_a_sign, stage0_b_sign;
    reg stage0_special, stage0_nan, stage0_inf, stage0_zero;
    
    // Pipeline stage 1: Multiplication
    reg [47:0] stage1_product;
    reg [8:0] stage1_exp_sum;
    reg stage1_sign;
    reg stage1_special, stage1_nan, stage1_inf, stage1_zero;
    
    // Pipeline stage 2: Normalization and rounding
    reg [23:0] stage2_mantissa;
    reg [8:0] stage2_exponent;
    reg stage2_sign;
    reg stage2_guard, stage2_round, stage2_sticky;
    reg stage2_special, stage2_nan, stage2_inf, stage2_zero;
    
    // Combinational logic between stages
    
    // Stage 0: Input processing
    wire [23:0] a_mantissa = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_mantissa = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire any_nan = a_nan || b_nan;
    wire inf_zero = (a_inf && b_zero) || (b_inf && a_zero);
    
    // Stage 1: Wallace tree multiplier (simplified for readability)
    wire [47:0] product = stage0_a_mant * stage0_b_mant;
    wire [8:0] exp_sum = {1'b0, stage0_a_exp} + {1'b0, stage0_b_exp} - 9'd127;
    
    // Stage 2: Normalization and rounding
    wire product_msb = stage1_product[47];
    wire [23:0] norm_mantissa = product_msb ? stage1_product[47:24] : stage1_product[46:23];
    wire [8:0] norm_exponent = product_msb ? (stage1_exp_sum + 1) : stage1_exp_sum;
    
    // Rounding logic
    wire round_inc = stage2_guard && (stage2_round || stage2_sticky || stage2_mantissa[0]);
    wire [23:0] rounded_mantissa = round_inc ? stage2_mantissa + 1 : stage2_mantissa;
    wire [8:0] rounded_exponent = (&stage2_mantissa && round_inc) ? 
                                 stage2_exponent + 1 : stage2_exponent;
    
    // Overflow/underflow detection
    wire overflow = (rounded_exponent >= 255) || (&rounded_exponent[7:0]);
    wire underflow = (rounded_exponent == 0) || (rounded_exponent[8]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage2_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage2_sign, 31'b0};
    wire [31:0] normal_out = {stage2_sign, 
                            overflow ? 8'hFF : underflow ? 8'h00 : rounded_exponent[7:0], 
                            overflow ? 23'b0 : underflow ? 23'b0 : rounded_mantissa[22:0]};
    
    // Pipeline stage 0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage0_a_mant <= 0;
            stage0_b_mant <= 0;
            stage0_a_exp <= 0;
            stage0_b_exp <= 0;
            stage0_a_sign <= 0;
            stage0_b_sign <= 0;
            stage0_special <= 0;
            stage0_nan <= 0;
            stage0_inf <= 0;
            stage0_zero <= 0;
        end else begin
            stage0_a_mant <= a_mantissa;
            stage0_b_mant <= b_mantissa;
            stage0_a_exp <= a[30:23];
            stage0_b_exp <= b[30:23];
            stage0_a_sign <= a[31];
            stage0_b_sign <= b[31];
            
            // Special case pipeline
            stage0_nan <= any_nan || inf_zero;
            stage0_inf <= (a_inf || b_inf) && ~stage0_nan;
            stage0_zero <= (a_zero || b_zero) && ~stage0_nan;
            stage0_special <= stage0_nan || stage0_inf || stage0_zero;
        end
    end
    
    // Pipeline stage 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_product <= 0;
            stage1_exp_sum <= 0;
            stage1_sign <= 0;
            stage1_special <= 0;
            stage1_nan <= 0;
            stage1_inf <= 0;
            stage1_zero <= 0;
        end else begin
            stage1_product <= product;
            stage1_exp_sum <= exp_sum;
            stage1_sign <= stage0_a_sign ^ stage0_b_sign;
            
            // Pipeline special cases
            stage1_special <= stage0_special;
            stage1_nan <= stage0_nan;
            stage1_inf <= stage0_inf;
            stage1_zero <= stage0_zero;
        end
    end
    
    // Pipeline stage 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_mantissa <= 0;
            stage2_exponent <= 0;
            stage2_sign <= 0;
            stage2_guard <= 0;
            stage2_round <= 0;
            stage2_sticky <= 0;
            stage2_special <= 0;
            stage2_nan <= 0;
            stage2_inf <= 0;
            stage2_zero <= 0;
        end else begin
            stage2_mantissa <= norm_mantissa;
            stage2_exponent <= norm_exponent;
            stage2_sign <= stage1_sign;
            stage2_guard <= stage1_product[22];
            stage2_round <= stage1_product[21];
            stage2_sticky <= |stage1_product[20:0];
            
            // Pipeline special cases
            stage2_special <= stage1_special;
            stage2_nan <= stage1_nan;
            stage2_inf <= stage1_inf;
            stage2_zero <= stage1_zero;
        end
    end
    
    // Output stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (stage2_nan) begin
                z <= nan_out;
            end
            else if (stage2_inf) begin
                z <= inf_out;
            end
            else if (stage2_zero) begin
                z <= zero_out;
            end
            else begin
                z <= normal_out;
            end
        end
    end

endmodule