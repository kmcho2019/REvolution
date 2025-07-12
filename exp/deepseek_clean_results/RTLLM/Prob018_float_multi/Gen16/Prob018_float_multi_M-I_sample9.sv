module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    input valid_in,
    output reg [31:0] z,
    output reg valid_out
);

    // Pipeline control
    reg [1:0] stage_valid;
    
    // Pipeline stage 1: Input extraction and special case detection
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    reg stage1_special, stage1_nan, stage1_inf, stage1_zero;
    
    // Pipeline stage 2: Partial multiplication and exponent calculation
    reg [23:0] stage2_a_mant, stage2_b_mant;
    reg [7:0] stage2_exp_sum;
    reg stage2_sign;
    reg [23:0] stage2_pp0, stage2_pp1, stage2_pp2;
    reg stage2_special, stage2_nan, stage2_inf, stage2_zero;
    reg stage2_sticky;
    
    // Pipeline stage 3: Final addition and normalization
    reg [47:0] stage3_product;
    reg [7:0] stage3_exponent;
    reg stage3_sign;
    reg stage3_special, stage3_nan, stage3_inf, stage3_zero;
    reg stage3_guard, stage3_round;
    
    // Combinational extraction and special case detection
    wire [23:0] a_mantissa = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_mantissa = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    wire nan_case = a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
    wire inf_case = (a_inf | b_inf) & ~nan_case;
    wire zero_case = (a_zero | b_zero) & ~nan_case;
    
    // Partial product generation
    wire [23:0] pp0 = stage2_a_mant & {24{stage2_b_mant[0]}};
    wire [23:0] pp1 = stage2_a_mant & {24{stage2_b_mant[1]}};
    wire [23:0] pp2 = stage2_a_mant & {24{stage2_b_mant[2]}};
    wire [47:0] full_product = {24'b0, pp0} + ({23'b0, pp1, 1'b0}) + ({22'b0, pp2, 2'b0});
    
    // Normalization and rounding
    wire product_msb = stage3_product[47];
    wire [23:0] norm_mantissa = product_msb ? stage3_product[47:24] : stage3_product[46:23];
    wire [7:0] norm_exponent = product_msb ? (stage3_exponent + 1) : stage3_exponent;
    wire round_inc = stage3_guard && (stage3_round || stage3_product[22] || stage3_sticky);
    wire [23:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [7:0] rounded_exponent = (&norm_mantissa && round_inc) ? norm_exponent + 1 : norm_exponent;
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage3_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage3_sign, 31'b0};
    wire [31:0] normal_out = {stage3_sign, rounded_exponent, rounded_mantissa[22:0]};
    
    // Clock gating enables
    wire stage1_en = valid_in | rst;
    wire stage2_en = stage_valid[0] | rst;
    wire stage3_en = stage_valid[1] | rst;
    
    // Pipeline stage 1: Input extraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_a_mant <= 0;
            stage1_b_mant <= 0;
            stage1_a_exp <= 0;
            stage1_b_exp <= 0;
            stage1_a_sign <= 0;
            stage1_b_sign <= 0;
            stage1_special <= 0;
            stage1_nan <= 0;
            stage1_inf <= 0;
            stage1_zero <= 0;
            stage_valid[0] <= 0;
        end else if (stage1_en) begin
            stage1_a_mant <= a_mantissa;
            stage1_b_mant <= b_mantissa;
            stage1_a_exp <= a[30:23];
            stage1_b_exp <= b[30:23];
            stage1_a_sign <= a[31];
            stage1_b_sign <= b[31];
            stage1_special <= special_case;
            stage1_nan <= nan_case;
            stage1_inf <= inf_case;
            stage1_zero <= zero_case;
            stage_valid[0] <= valid_in;
        end
    end
    
    // Pipeline stage 2: Partial multiplication
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_a_mant <= 0;
            stage2_b_mant <= 0;
            stage2_exp_sum <= 0;
            stage2_sign <= 0;
            stage2_pp0 <= 0;
            stage2_pp1 <= 0;
            stage2_pp2 <= 0;
            stage2_special <= 0;
            stage2_nan <= 0;
            stage2_inf <= 0;
            stage2_zero <= 0;
            stage2_sticky <= 0;
            stage_valid[1] <= 0;
        end else if (stage2_en) begin
            stage2_a_mant <= stage1_a_mant;
            stage2_b_mant <= stage1_b_mant;
            stage2_exp_sum <= stage1_a_exp + stage1_b_exp - 8'd127;
            stage2_sign <= stage1_a_sign ^ stage1_b_sign;
            stage2_pp0 <= pp0;
            stage2_pp1 <= pp1;
            stage2_pp2 <= pp2;
            stage2_special <= stage1_special;
            stage2_nan <= stage1_nan;
            stage2_inf <= stage1_inf;
            stage2_zero <= stage1_zero;
            stage2_sticky <= |stage2_b_mant[23:3];
            stage_valid[1] <= stage_valid[0];
        end
    end
    
    // Pipeline stage 3: Final addition and normalization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage3_product <= 0;
            stage3_exponent <= 0;
            stage3_sign <= 0;
            stage3_special <= 0;
            stage3_nan <= 0;
            stage3_inf <= 0;
            stage3_zero <= 0;
            stage3_guard <= 0;
            stage3_round <= 0;
            valid_out <= 0;
        end else if (stage3_en) begin
            stage3_product <= full_product;
            stage3_exponent <= stage2_exp_sum;
            stage3_sign <= stage2_sign;
            stage3_special <= stage2_special;
            stage3_nan <= stage2_nan;
            stage3_inf <= stage2_inf;
            stage3_zero <= stage2_zero;
            stage3_guard <= stage2_b_mant[2];
            stage3_round <= stage2_b_mant[1];
            valid_out <= stage_valid[1];
        end
    end
    
    // Output stage
    always @(*) begin
        if (stage3_nan) begin
            z = nan_out;
        end
        else if (stage3_inf) begin
            z = inf_out;
        end
        else if (stage3_zero) begin
            z = zero_out;
        end
        else if (rounded_exponent[7:0] == 8'hFF) begin // Overflow
            z = inf_out;
        end
        else if (rounded_exponent[7:0] == 0) begin // Underflow
            z = zero_out;
        end
        else begin
            z = normal_out;
        end
    end

endmodule