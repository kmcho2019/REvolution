module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage registers
    reg [31:0] stage0_a, stage0_b;
    reg [1:0] pipeline_stage;
    
    // Special case detection (combinational)
    wire a_zero = (stage0_a[30:0] == 0);
    wire b_zero = (stage0_b[30:0] == 0);
    wire a_inf = (&stage0_a[30:23]) && (stage0_a[22:0] == 0);
    wire b_inf = (&stage0_b[30:23]) && (stage0_b[22:0] == 0);
    wire a_nan = (&stage0_a[30:23]) && (|stage0_a[22:0]);
    wire b_nan = (&stage0_b[30:23]) && (|stage0_b[22:0]);
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    wire inf_case = (a_inf || b_inf) && ~special_case;
    wire zero_case = (a_zero || b_zero) && ~special_case;
    
    // Stage 1: Input processing
    wire a_sign = stage0_a[31];
    wire b_sign = stage0_b[31];
    wire [7:0] a_exp = stage0_a[30:23];
    wire [7:0] b_exp = stage0_b[30:23];
    wire [23:0] a_mant = (|a_exp) ? {1'b1, stage0_a[22:0]} : {1'b0, stage0_a[22:0]};
    wire [23:0] b_mant = (|b_exp) ? {1'b1, stage0_b[22:0]} : {1'b0, stage0_b[22:0]};
    
    // Stage 1 registers
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    reg stage1_special, stage1_inf, stage1_zero, stage1_nan;
    
    // Stage 2: Multiplication and exponent
    wire [47:0] product = stage1_a_mant * stage1_b_mant;
    wire [8:0] exp_sum = {1'b0, stage1_a_exp} + {1'b0, stage1_b_exp} - 9'd127;
    wire stage2_sign = stage1_a_sign ^ stage1_b_sign;
    
    // Stage 2 registers
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp_sum;
    reg stage2_sign;
    reg stage2_special, stage2_inf, stage2_zero, stage2_nan;
    
    // Stage 3: Normalization and rounding
    wire product_msb = stage2_product[47];
    wire [23:0] norm_mantissa = product_msb ? stage2_product[47:24] : stage2_product[46:23];
    wire [8:0] norm_exponent = product_msb ? (stage2_exp_sum + 1) : stage2_exp_sum;
    
    // Rounding logic
    wire guard_bit = stage2_product[22];
    wire round_bit = stage2_product[21];
    wire sticky = |stage2_product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky);
    wire [23:0] rounded_mantissa = norm_mantissa + (round_inc ? 1 : 0);
    
    // Overflow/underflow detection
    wire overflow = (norm_exponent >= 255) || (&norm_exponent[7:0] && round_inc);
    wire underflow = (norm_exponent == 0) || (norm_exponent[8]);
    
    // Output selection
    wire [31:0] normal_out = {stage2_sign, 
                             overflow ? 8'hFF : underflow ? 8'h00 : norm_exponent[7:0], 
                             overflow ? 23'b0 : underflow ? 23'b0 : rounded_mantissa[22:0]};
    
    // Pipeline control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_stage <= 0;
            {stage0_a, stage0_b} <= 0;
            {stage1_a_mant, stage1_b_mant, stage1_a_exp, stage1_b_exp} <= 0;
            {stage1_a_sign, stage1_b_sign, stage1_special, stage1_inf, stage1_zero, stage1_nan} <= 0;
            {stage2_product, stage2_exp_sum, stage2_sign} <= 0;
            {stage2_special, stage2_inf, stage2_zero, stage2_nan} <= 0;
            z <= 0;
        end else begin
            case (pipeline_stage)
                0: begin // Input stage
                    stage0_a <= a;
                    stage0_b <= b;
                    pipeline_stage <= 1;
                end
                
                1: begin // Decode stage
                    stage1_a_mant <= a_mant;
                    stage1_b_mant <= b_mant;
                    stage1_a_exp <= a_exp;
                    stage1_b_exp <= b_exp;
                    stage1_a_sign <= a_sign;
                    stage1_b_sign <= b_sign;
                    stage1_special <= special_case;
                    stage1_inf <= inf_case;
                    stage1_zero <= zero_case;
                    stage1_nan <= a_nan || b_nan;
                    pipeline_stage <= 2;
                end
                
                2: begin // Multiply stage
                    stage2_product <= product;
                    stage2_exp_sum <= exp_sum;
                    stage2_sign <= stage2_sign;
                    stage2_special <= stage1_special;
                    stage2_inf <= stage1_inf;
                    stage2_zero <= stage1_zero;
                    stage2_nan <= stage1_nan;
                    pipeline_stage <= 3;
                end
                
                3: begin // Output stage
                    if (stage2_nan) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Canonical NaN
                    end else if (stage2_inf) begin
                        z <= {stage2_sign, 8'hFF, 23'b0};
                    end else if (stage2_zero) begin
                        z <= {stage2_sign, 31'b0};
                    end else begin
                        z <= normal_out;
                    end
                    pipeline_stage <= 0;
                end
            endcase
        end
    end

endmodule