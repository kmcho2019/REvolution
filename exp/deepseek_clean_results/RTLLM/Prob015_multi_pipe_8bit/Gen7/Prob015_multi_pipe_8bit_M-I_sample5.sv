module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control signals
    wire clk_gated;
    reg [3:0] en_pipeline;

    // Clock gating when mul_en_in is low
    assign clk_gated = clk & (mul_en_in | (|en_pipeline));

    // Pipeline Stage 1: Input Registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline Stage 2: Partial Product Generation
    reg [15:0] pp [7:0];
    reg stage2_en;
    
    // Pipeline Stage 3: First Level Reduction (4:2 compressor)
    reg [15:0] sum_a, sum_b;
    reg [15:0] carry_a, carry_b;
    reg stage3_en;
    
    // Pipeline Stage 4: Final Addition
    reg [15:0] stage4_result;
    reg stage4_en;
    
    // Generate all partial products with operand isolation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(*) begin
                if (stage1_en) begin
                    pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
                end else begin
                    pp[i] = 16'b0;
                end
            end
        end
    endgenerate
    
    // First level reduction (4:2 compressor)
    wire [15:0] sum_s1, carry_s1;
    wire [15:0] sum_s2, carry_s2;
    
    // First 4:2 compressor stage
    assign sum_s1 = pp[0] ^ pp[1] ^ pp[2] ^ pp[3];
    assign carry_s1 = ((pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2])) ^ pp[3];
    
    // Second 4:2 compressor stage
    assign sum_s2 = pp[4] ^ pp[5] ^ pp[6] ^ pp[7];
    assign carry_s2 = ((pp[4] & pp[5]) | (pp[4] & pp[6]) | (pp[5] & pp[6])) ^ pp[7];
    
    // Pipeline Stage 1: Input Registration
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            en_pipeline[0] <= 1'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            en_pipeline[0] <= mul_en_in;
        end
    end
    
    // Pipeline Stage 2: Partial Product Generation
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage2_en <= 1'b0;
            en_pipeline[1] <= 1'b0;
        end else begin
            stage2_en <= stage1_en;
            en_pipeline[1] <= en_pipeline[0];
        end
    end
    
    // Pipeline Stage 3: First Level Reduction
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            sum_a <= 16'b0;
            sum_b <= 16'b0;
            carry_a <= 16'b0;
            carry_b <= 16'b0;
            stage3_en <= 1'b0;
            en_pipeline[2] <= 1'b0;
        end else begin
            sum_a <= sum_s1;
            sum_b <= sum_s2;
            carry_a <= carry_s1 << 1;
            carry_b <= carry_s2 << 1;
            stage3_en <= stage2_en;
            en_pipeline[2] <= en_pipeline[1];
        end
    end
    
    // Pipeline Stage 4: Final Addition
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            stage4_result <= 16'b0;
            stage4_en <= 1'b0;
            en_pipeline[3] <= 1'b0;
        end else begin
            stage4_result <= (sum_a + sum_b) + (carry_a + carry_b);
            stage4_en <= stage3_en;
            en_pipeline[3] <= en_pipeline[2];
        end
    end
    
    // Output assignments
    assign mul_en_out = stage4_en;
    assign mul_out = stage4_en ? stage4_result : 16'b0;

endmodule