module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1: Input extraction and special case detection
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    reg stage1_is_nan, stage1_is_inf, stage1_is_zero;
    
    // Pipeline stage 2: Multiplication and exponent calculation
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp_sum; // 9-bit for overflow detection
    reg stage2_sign;
    reg stage2_is_nan, stage2_is_inf, stage2_is_zero;
    
    // Pipeline stage 3: Normalization and rounding
    reg [22:0] stage3_mantissa;
    reg [7:0] stage3_exponent;
    reg stage3_sign;
    reg stage3_is_nan, stage3_is_inf, stage3_is_zero;
    reg stage3_guard, stage3_round, stage3_sticky;
    
    // Combinational extraction logic
    wire [23:0] a_mantissa = {|a[30:23], a[22:0]};
    wire [23:0] b_mantissa = {|b[30:23], b[22:0]};
    
    // Shared comparator logic for special cases
    wire a_exp_all1 = &a[30:23];
    wire b_exp_all1 = &b[30:23];
    wire a_exp_all0 = ~|a[30:23];
    wire b_exp_all0 = ~|b[30:23];
    wire a_frac_all0 = ~|a[22:0];
    wire b_frac_all0 = ~|b[22:0];
    
    // Special case detection (combinational)
    wire a_nan = a_exp_all1 & ~a_frac_all0;
    wire b_nan = b_exp_all1 & ~b_frac_all0;
    wire a_inf = a_exp_all1 & a_frac_all0;
    wire b_inf = b_exp_all1 & b_frac_all0;
    wire a_zero = a_exp_all0 & a_frac_all0;
    wire b_zero = b_exp_all0 & b_frac_all0;
    
    wire is_nan = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
    wire is_inf = a_inf | b_inf;
    wire is_zero = a_zero | b_zero;
    
    // Clock gating for multiplier when inputs are zero
    wire mult_enable = ~(a_zero | b_zero);
    wire [47:0] product = mult_enable ? stage1_a_mant * stage1_b_mant : 48'b0;
    
    // Exponent calculation with 9-bit for overflow detection
    wire [8:0] exp_sum = {1'b0, stage1_a_exp} + {1'b0, stage1_b_exp} - 9'd127;
    
    // Normalization and rounding bits
    wire product_msb = stage2_product[47];
    wire [22:0] norm_mantissa = product_msb ? stage2_product[46:24] : stage2_product[45:23];
    wire guard_bit = product_msb ? stage2_product[23] : stage2_product[22];
    wire round_bit = product_msb ? stage2_product[22] : stage2_product[21];
    wire sticky_bit = product_msb ? (|stage2_product[21:0]) : (|stage2_product[20:0]);
    
    // Optimized rounding logic
    wire round_inc = guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);
    wire [22:0] rounded_mantissa = norm_mantissa + {22'b0, round_inc};
    wire [8:0] rounded_exponent = {1'b0, stage3_exponent} + {8'b0, &norm_mantissa & round_inc};
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage3_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage3_sign, 31'b0};
    wire [31:0] normal_out = {stage3_sign, rounded_exponent[7:0], rounded_mantissa};
    
    // Pipeline stage 1: Input extraction and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a_mant <= 0;
            stage1_b_mant <= 0;
            stage1_a_exp <= 0;
            stage1_b_exp <= 0;
            stage1_a_sign <= 0;
            stage1_b_sign <= 0;
            stage1_is_nan <= 0;
            stage1_is_inf <= 0;
            stage1_is_zero <= 0;
        end else begin
            stage1_a_mant <= a_mantissa;
            stage1_b_mant <= b_mantissa;
            stage1_a_exp <= a[30:23];
            stage1_b_exp <= b[30:23];
            stage1_a_sign <= a[31];
            stage1_b_sign <= b[31];
            stage1_is_nan <= is_nan;
            stage1_is_inf <= is_inf;
            stage1_is_zero <= is_zero;
        end
    end
    
    // Pipeline stage 2: Multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_product <= 0;
            stage2_exp_sum <= 0;
            stage2_sign <= 0;
            stage2_is_nan <= 0;
            stage2_is_inf <= 0;
            stage2_is_zero <= 0;
        end else begin
            stage2_product <= product;
            stage2_exp_sum <= exp_sum + {8'b0, product_msb}; // Include normalization shift
            stage2_sign <= stage1_a_sign ^ stage1_b_sign;
            stage2_is_nan <= stage1_is_nan;
            stage2_is_inf <= stage1_is_inf;
            stage2_is_zero <= stage1_is_zero;
        end
    end
    
    // Pipeline stage 3: Normalization and rounding preparation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage3_mantissa <= 0;
            stage3_exponent <= 0;
            stage3_sign <= 0;
            stage3_is_nan <= 0;
            stage3_is_inf <= 0;
            stage3_is_zero <= 0;
            stage3_guard <= 0;
            stage3_round <= 0;
            stage3_sticky <= 0;
        end else begin
            stage3_mantissa <= norm_mantissa;
            stage3_exponent <= stage2_exp_sum[7:0];
            stage3_sign <= stage2_sign;
            stage3_is_nan <= stage2_is_nan;
            stage3_is_inf <= stage2_is_inf;
            stage3_is_zero <= stage2_is_zero;
            stage3_guard <= guard_bit;
            stage3_round <= round_bit;
            stage3_sticky <= sticky_bit;
        end
    end
    
    // Output stage with priority encoding
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            case (1'b1)
                stage3_is_nan: z <= nan_out;
                stage3_is_inf: z <= inf_out;
                stage3_is_zero: z <= zero_out;
                rounded_exponent[8] || &rounded_exponent[7:0]: z <= inf_out; // Overflow
                (rounded_exponent[7:0] == 0): z <= zero_out; // Underflow
                default: z <= normal_out;
            endcase
        end
    end

endmodule