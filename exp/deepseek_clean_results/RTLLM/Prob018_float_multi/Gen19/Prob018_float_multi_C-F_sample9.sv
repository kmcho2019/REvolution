module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1: Input extraction
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    
    // Pipeline stage 2: Multiplication
    reg [47:0] stage2_product;
    reg [7:0] stage2_exp_sum;
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
    
    // Special case detection (combinational)
    wire a_nan = (&a[30:23]) & (|a[22:0]);
    wire b_nan = (&b[30:23]) & (|b[22:0]);
    wire a_inf = (&a[30:23]) & (~|a[22:0]);
    wire b_inf = (&b[30:23]) & (~|b[22:0]);
    wire a_zero = (~|a[30:23]) & (~|a[22:0]);
    wire b_zero = (~|b[30:23]) & (~|b[22:0]);
    
    wire is_nan = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
    wire is_inf = a_inf | b_inf;
    wire is_zero = a_zero | b_zero;
    
    // Combinational multiplication logic
    wire [47:0] product = stage1_a_mant * stage1_b_mant;
    wire product_msb = product[47];
    wire [7:0] exp_sum = stage1_a_exp + stage1_b_exp - 8'd127 + product_msb;
    
    // Combinational normalization logic
    wire [22:0] norm_mantissa = product_msb ? product[46:24] : product[45:23];
    wire guard_bit = product_msb ? product[23] : product[22];
    wire round_bit = product_msb ? product[22] : product[21];
    wire sticky_bit = product_msb ? (|product[21:0]) : (|product[20:0]);
    
    // Combinational rounding logic
    wire round_inc = guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);
    wire [22:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [7:0] rounded_exponent = (&norm_mantissa & round_inc) ? 
                                 stage3_exponent + 1 : stage3_exponent;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage3_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage3_sign, 31'b0};
    wire [31:0] normal_out = {stage3_sign, rounded_exponent, rounded_mantissa};
    
    // Pipeline stage 1: Input extraction and special case detection
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
            stage2_exp_sum <= exp_sum;
            stage2_sign <= stage1_a_sign ^ stage1_b_sign;
            stage2_is_nan <= is_nan;
            stage2_is_inf <= is_inf;
            stage2_is_zero <= is_zero;
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
            stage3_exponent <= stage2_exp_sum;
            stage3_sign <= stage2_sign;
            stage3_is_nan <= stage2_is_nan;
            stage3_is_inf <= stage2_is_inf;
            stage3_is_zero <= stage2_is_zero;
            stage3_guard <= guard_bit;
            stage3_round <= round_bit;
            stage3_sticky <= sticky_bit;
        end
    end
    
    // Output stage
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            case (1'b1)
                stage3_is_nan: z <= nan_out;
                stage3_is_inf: z <= inf_out;
                stage3_is_zero: z <= zero_out;
                (&rounded_exponent | (rounded_exponent >= 8'hFE)): z <= inf_out; // Overflow
                (rounded_exponent[7] & (rounded_exponent != 8'hFF)): z <= zero_out; // Underflow
                default: z <= normal_out;
            endcase
        end
    end

endmodule