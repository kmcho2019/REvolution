module adder_pipe_64bit(
    input  clk,
    input  rst_n,
    input  i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg [7:0] stage1_en;

reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg [7:0] stage2_en;

reg [63:0] stage3_a;
reg [63:0] stage3_b;
reg [7:0] stage3_en;

reg [63:0] stage4_a;
reg [63:0] stage4_b;
reg [7:0] stage4_en;

reg [63:0] stage5_a;
reg [63:0] stage5_b;
reg [7:0] stage5_en;

reg [63:0] stage6_a;
reg [63:0] stage6_b;
reg [7:0] stage6_en;

reg [63:0] stage7_a;
reg [63:0] stage7_b;
reg [7:0] stage7_en;

reg [63:0] stage8_a;
reg [63:0] stage8_b;
reg [7:0] stage8_en;

reg [63:0] stage1_sum;
reg [63:0] stage2_sum;
reg [63:0] stage3_sum;
reg [63:0] stage4_sum;
reg [63:0] stage5_sum;
reg [63:0] stage6_sum;
reg [63:0] stage7_sum;
reg [63:0] stage8_sum;

reg [7:0] carry1;
reg [7:0] carry2;
reg [7:0] carry3;
reg [7:0] carry4;
reg [7:0] carry5;
reg [7:0] carry6;
reg [7:0] carry7;
reg [7:0] carry8;

reg [7:0] o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 8'd0;
        
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage2_en <= 8'd0;
        
        stage3_a <= 64'd0;
        stage3_b <= 64'd0;
        stage3_en <= 8'd0;
        
        stage4_a <= 64'd0;
        stage4_b <= 64'd0;
        stage4_en <= 8'd0;
        
        stage5_a <= 64'd0;
        stage5_b <= 64'd0;
        stage5_en <= 8'd0;
        
        stage6_a <= 64'd0;
        stage6_b <= 64'd0;
        stage6_en <= 8'd0;
        
        stage7_a <= 64'd0;
        stage7_b <= 64'd0;
        stage7_en <= 8'd0;
        
        stage8_a <= 64'd0;
        stage8_b <= 64'd0;
        stage8_en <= 8'd0;
        
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage3_sum <= 64'd0;
        stage4_sum <= 64'd0;
        stage5_sum <= 64'd0;
        stage6_sum <= 64'd0;
        stage7_sum <= 64'd0;
        stage8_sum <= 64'd0;
        
        carry1 <= 8'd0;
        carry2 <= 8'd0;
        carry3 <= 8'd0;
        carry4 <= 8'd0;
        carry5 <= 8'd0;
        carry6 <= 8'd0;
        carry7 <= 8'd0;
        carry8 <= 8'd0;
        
        o_en_reg <= 1'd0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= 8'd1;
        
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        stage2_en <= stage1_en;
        
        stage3_a <= stage2_a;
        stage3_b <= stage2_b;
        stage3_en <= stage2_en;
        
        stage4_a <= stage3_a;
        stage4_b <= stage3_b;
        stage4_en <= stage3_en;
        
        stage5_a <= stage4_a;
        stage5_b <= stage4_b;
        stage5_en <= stage4_en;
        
        stage6_a <= stage5_a;
        stage6_b <= stage5_b;
        stage6_en <= stage5_en;
        
        stage7_a <= stage6_a;
        stage7_b <= stage6_b;
        stage7_en <= stage6_en;
        
        stage8_a <= stage7_a;
        stage8_b <= stage7_b;
        stage8_en <= stage7_en;
    end else begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 8'd0;
        
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage2_en <= 8'd0;
        
        stage3_a <= 64'd0;
        stage3_b <= 64'd0;
        stage3_en <= 8'd0;
        
        stage4_a <= 64'd0;
        stage4_b <= 64'd0;
        stage4_en <= 8'd0;
        
        stage5_a <= 64'd0;
        stage5_b <= 64'd0;
        stage5_en <= 8'd0;
        
        stage6_a <= 64'd0;
        stage6_b <= 64'd0;
        stage6_en <= 8'd0;
        
        stage7_a <= 64'd0;
        stage7_b <= 64'd0;
        stage7_en <= 8'd0;
        
        stage8_a <= 64'd0;
        stage8_b <= 64'd0;
        stage8_en <= 8'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage3_sum <= 64'd0;
        stage4_sum <= 64'd0;
        stage5_sum <= 64'd0;
        stage6_sum <= 64'd0;
        stage7_sum <= 64'd0;
        stage8_sum <= 64'd0;
        
        carry1 <= 8'd0;
        carry2 <= 8'd0;
        carry3 <= 8'd0;
        carry4 <= 8'd0;
        carry5 <= 8'd0;
        carry6 <= 8'd0;
        carry7 <= 8'd0;
        carry8 <= 8'd0;
    end else begin
        // Calculate sum and carry for each stage
        stage1_sum <= {stage1_a[7:0] + stage1_b[7:0] + carry1, stage1_a[15:8] + stage1_b[15:8] + carry2, stage1_a[23:16] + stage1_b[23:16] + carry3, stage1_a[31:24] + stage1_b[31:24] + carry4, 
                        stage1_a[39:32] + stage1_b[39:32] + carry5, stage1_a[47:40] + stage1_b[47:40] + carry6, stage1_a[55:48] + stage1_b[55:48] + carry7, stage1_a[63:56] + stage1_b[63:56] + carry8};
        
        stage2_sum <= {stage2_a[7:0] + stage2_b[7:0] + carry1, stage2_a[15:8] + stage2_b[15:8] + carry2, stage2_a[23:16] + stage2_b[23:16] + carry3, stage2_a[31:24] + stage2_b[31:24] + carry4, 
                        stage2_a[39:32] + stage2_b[39:32] + carry5, stage2_a[47:40] + stage2_b[47:40] + carry6, stage2_a[55:48] + stage2_b[55:48] + carry7, stage2_a[63:56] + stage2_b[63:56] + carry8};
        
        stage3_sum <= {stage3_a[7:0] + stage3_b[7:0] + carry1, stage3_a[15:8] + stage3_b[15:8] + carry2, stage3_a[23:16] + stage3_b[23:16] + carry3, stage3_a[31:24] + stage3_b[31:24] + carry4, 
                        stage3_a[39:32] + stage3_b[39:32] + carry5, stage3_a[47:40] + stage3_b[47:40] + carry6, stage3_a[55:48] + stage3_b[55:48] + carry7, stage3_a[63:56] + stage3_b[63:56] + carry8};
        
        stage4_sum <= {stage4_a[7:0] + stage4_b[7:0] + carry1, stage4_a[15:8] + stage4_b[15:8] + carry2, stage4_a[23:16] + stage4_b[23:16] + carry3, stage4_a[31:24] + stage4_b[31:24] + carry4, 
                        stage4_a[39:32] + stage4_b[39:32] + carry5, stage4_a[47:40] + stage4_b[47:40] + carry6, stage4_a[55:48] + stage4_b[55:48] + carry7, stage4_a[63:56] + stage4_b[63:56] + carry8};
        
        stage5_sum <= {stage5_a[7:0] + stage5_b[7:0] + carry1, stage5_a[15:8] + stage5_b[15:8] + carry2, stage5_a[23:16] + stage5_b[23:16] + carry3, stage5_a[31:24] + stage5_b[31:24] + carry4, 
                        stage5_a[39:32] + stage5_b[39:32] + carry5, stage5_a[47:40] + stage5_b[47:40] + carry6, stage5_a[55:48] + stage5_b[55:48] + carry7, stage5_a[63:56] + stage5_b[63:56] + carry8};
        
        stage6_sum <= {stage6_a[7:0] + stage6_b[7:0] + carry1, stage6_a[15:8] + stage6_b[15:8] + carry2, stage6_a[23:16] + stage6_b[23:16] + carry3, stage6_a[31:24] + stage6_b[31:24] + carry4, 
                        stage6_a[39:32] + stage6_b[39:32] + carry5, stage6_a[47:40] + stage6_b[47:40] + carry6, stage6_a[55:48] + stage6_b[55:48] + carry7, stage6_a[63:56] + stage6_b[63:56] + carry8};
        
        stage7_sum <= {stage7_a[7:0] + stage7_b[7:0] + carry1, stage7_a[15:8] + stage7_b[15:8] + carry2, stage7_a[23:16] + stage7_b[23:16] + carry3, stage7_a[31:24] + stage7_b[31:24] + carry4, 
                        stage7_a[39:32] + stage7_b[39:32] + carry5, stage7_a[47:40] + stage7_b[47:40] + carry6, stage7_a[55:48] + stage7_b[55:48] + carry7, stage7_a[63:56] + stage7_b[63:56] + carry8};
        
        stage8_sum <= {stage8_a[7:0] + stage8_b[7:0] + carry1, stage8_a[15:8] + stage8_b[15:8] + carry2, stage8_a[23:16] + stage8_b[23:16] + carry3, stage8_a[31:24] + stage8_b[31:24] + carry4, 
                        stage8_a[39:32] + stage8_b[39:32] + carry5, stage8_a[47:40] + stage8_b[47:40] + carry6, stage8_a[55:48] + stage8_b[55:48] + carry7, stage8_a[63:56] + stage8_b[63:56] + carry8};
        
        // Calculate carry for each stage
        carry1 <= (stage1_a[7:0] + stage1_b[7:0] + carry1) >> 8;
        carry2 <= (stage1_a[15:8] + stage1_b[15:8] + carry2) >> 8;
        carry3 <= (stage1_a[23:16] + stage1_b[23:16] + carry3) >> 8;
        carry4 <= (stage1_a[31:24] + stage1_b[31:24] + carry4) >> 8;
        carry5 <= (stage1_a[39:32] + stage1_b[39:32] + carry5) >> 8;
        carry6 <= (stage1_a[47:40] + stage1_b[47:40] + carry6) >> 8;
        carry7 <= (stage1_a[55:48] + stage1_b[55:48] + carry7) >> 8;
        carry8 <= (stage1_a[63:56] + stage1_b[63:56] + carry8) >> 8;
        
        o_en_reg <= stage8_en;
    end
end

always @(posedge clk) begin
    result <= {1'b0, stage8_sum};
    o_en <= o_en_reg;
end

endmodule