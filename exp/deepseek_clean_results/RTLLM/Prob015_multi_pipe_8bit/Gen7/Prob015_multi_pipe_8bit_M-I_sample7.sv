module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating signals
    wire clk_gated;
    wire clk_enable;

    // Pipeline Stage 1: Input Registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline Stage 2: Partial Product Generation
    reg [15:0] stage2_pp [7:0];
    reg stage2_en;
    
    // Pipeline Stage 3: Intermediate Sum (Carry-Save)
    reg [15:0] stage3_sum0, stage3_sum1;
    reg [15:0] stage3_carry;
    reg stage3_en;
    
    // Pipeline Stage 4: Final Sum
    reg [15:0] stage4_result;
    reg stage4_en;
    
    // Clock gating implementation
    assign clk_enable = mul_en_in | stage1_en | stage2_en | stage3_en;
    CLK_GATE clk_gate (.CLK(clk), .EN(clk_enable), .GCLK(clk_gated));
    
    // Generate all partial products with operand isolation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            wire [15:0] pp_raw;
            assign pp_raw = {8'b0, stage1_a} << i;
            assign stage2_pp[i] = (stage1_en & stage1_b[i]) ? pp_raw : 16'b0;
        end
    endgenerate
    
    // Pipeline Stage 1: Input Registration
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
        end
    end
    
    // Pipeline Stage 2: Partial Product Registration
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage2_en <= 1'b0;
        end else begin
            stage2_en <= stage1_en;
        end
    end
    
    // Carry-Save addition for first level
    wire [15:0] sum_level1_0, sum_level1_1;
    wire [15:0] carry_level1;
    
    assign {carry_level1, sum_level1_0} = stage2_pp[0] + stage2_pp[1] + stage2_pp[2];
    assign sum_level1_1 = stage2_pp[3] + stage2_pp[4] + stage2_pp[5];
    
    // Pipeline Stage 3: Intermediate Sum
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage3_sum0 <= 16'b0;
            stage3_sum1 <= 16'b0;
            stage3_carry <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            stage3_sum0 <= sum_level1_0;
            stage3_sum1 <= sum_level1_1;
            stage3_carry <= carry_level1;
            stage3_en <= stage2_en;
        end
    end
    
    // Final addition
    wire [15:0] final_sum;
    assign final_sum = stage3_sum0 + stage3_sum1 + stage3_carry + stage2_pp[6] + stage2_pp[7];
    
    // Pipeline Stage 4: Final Result
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage4_result <= 16'b0;
            stage4_en <= 1'b0;
        end else begin
            stage4_result <= final_sum;
            stage4_en <= stage3_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage4_en;
    assign mul_out = stage4_en ? stage4_result : 16'b0;

endmodule

// Clock gating cell
module CLK_GATE (
    input CLK,
    input EN,
    output GCLK
);
    // Implementation of clock gating cell
    // This would typically be a technology-specific cell
    reg gated;
    always @(CLK or EN) begin
        if (!CLK) gated <= EN;
    end
    assign GCLK = CLK & gated;
endmodule