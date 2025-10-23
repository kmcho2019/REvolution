module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1: Input decomposition
    reg [23:0] stage1_a_man, stage1_b_man;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg stage1_a_sign, stage1_b_sign;
    
    // Pipeline stage 2: Multiplication
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp_sum; // Extra bit for overflow detection
    reg stage2_sign;
    
    // Pipeline stage 3: Normalization and rounding
    reg [22:0] stage3_man;
    reg [7:0] stage3_exp;
    reg stage3_sign;
    
    // Combinational extraction
    wire [23:0] a_man = (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Special case detection (combinational)
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire a_inf = (&a[30:23]) && (~|a[22:0]);
    wire b_inf = (&b[30:23]) && (~|b[22:0]);
    wire a_zero = ~|a[30:0];
    wire b_zero = ~|b[30:0];
    wire inf_zero = (a_inf && b_zero) || (b_inf && a_zero);
    
    // Pipeline stage 1: Input decomposition
    always @(posedge clk) begin
        if (rst) begin
            stage1_a_man <= 0;
            stage1_b_man <= 0;
            stage1_a_exp <= 0;
            stage1_b_exp <= 0;
            stage1_a_sign <= 0;
            stage1_b_sign <= 0;
        end else begin
            stage1_a_man <= a_man;
            stage1_b_man <= b_man;
            stage1_a_exp <= a[30:23];
            stage1_b_exp <= b[30:23];
            stage1_a_sign <= a[31];
            stage1_b_sign <= b[31];
        end
    end
    
    // Pipeline stage 2: Multiplication
    wire [47:0] product = stage1_a_man * stage1_b_man;
    wire [8:0] exp_sum = {1'b0, stage1_a_exp} + {1'b0, stage1_b_exp} - 9'd127;
    
    always @(posedge clk) begin
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
    
    // Pipeline stage 3: Normalization and rounding
    wire norm_bit = stage2_product[47];
    wire [8:0] norm_exp = norm_bit ? stage2_exp_sum + 1 : stage2_exp_sum;
    wire [22:0] norm_man = norm_bit ? stage2_product[46:24] : stage2_product[45:23];
    
    always @(posedge clk) begin
        if (rst) begin
            stage3_man <= 0;
            stage3_exp <= 0;
            stage3_sign <= 0;
        end else begin
            stage3_man <= norm_man;
            stage3_exp <= norm_exp[7:0];
            stage3_sign <= stage2_sign;
        end
    end
    
    // Output selection
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (a_nan || b_nan || inf_zero) begin
                z <= 32'h7FC00000; // NaN
            end else if (a_inf || b_inf) begin
                z <= {stage3_sign, 8'hFF, 23'b0}; // Infinity
            end else if (a_zero || b_zero) begin
                z <= {stage3_sign, 31'b0}; // Zero
            end else if (&norm_exp || (norm_exp == 0)) begin // Overflow/underflow
                z <= {stage3_sign, 8'hFF, 23'b0}; // Infinity
            end else begin
                z <= {stage3_sign, stage3_exp, stage3_man};
            end
        end
    end

endmodule