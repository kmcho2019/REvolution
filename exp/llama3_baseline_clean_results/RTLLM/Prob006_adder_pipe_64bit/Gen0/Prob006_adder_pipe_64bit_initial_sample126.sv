module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_a, stage1_b;
reg [63:0] stage2_a, stage2_b;
reg [63:0] stage3_a, stage3_b;
reg [63:0] stage4_a, stage4_b;
reg [1:0] stage1_cin, stage2_cin, stage3_cin, stage4_cin;
reg [1:0] stage1_cout, stage2_cout, stage3_cout, stage4_cout;
reg [63:0] stage1_sum, stage2_sum, stage3_sum, stage4_sum;
reg [64:0] final_sum;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage3_a <= 64'd0;
        stage3_b <= 64'd0;
        stage4_a <= 64'd0;
        stage4_b <= 64'd0;
        stage1_cin <= 2'd0;
        stage2_cin <= 2'd0;
        stage3_cin <= 2'd0;
        stage4_cin <= 2'd0;
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage3_sum <= 64'd0;
        stage4_sum <= 64'd0;
        final_sum <= 65'd0;
        o_en_reg <= 1'd0;
    end else if (i_en) begin
        stage1_a <= adda[63:32];
        stage1_b <= addb[63:32];
        stage2_a <= adda[31:0];
        stage2_b <= addb[31:0];
        stage3_a <= 64'd0;
        stage3_b <= 64'd0;
        stage4_a <= 64'd0;
        stage4_b <= 64'd0;
        stage1_cin <= 2'd0;
        stage2_cin <= 2'd0;
        stage3_cin <= 2'd0;
        stage4_cin <= 2'd0;
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage3_sum <= 64'd0;
        stage4_sum <= 64'd0;
        final_sum <= 65'd0;
        o_en_reg <= 1'd0;
    end else begin
        stage3_a <= stage1_sum[31:0];
        stage3_b <= stage2_sum[31:0];
        stage4_a <= stage3_sum[31:0];
        stage4_b <= stage2_sum[31:0];
        stage1_cin <= stage1_cout;
        stage2_cin <= stage2_cout;
        stage3_cin <= stage3_cout;
        stage4_cin <= stage4_cout;
        stage1_sum <= stage1_a + stage1_b + stage1_cin;
        stage2_sum <= stage2_a + stage2_b + stage2_cin;
        stage3_sum <= stage3_a + stage3_b + stage3_cin;
        stage4_sum <= stage4_a + stage4_b + stage4_cin;
        final_sum <= {stage4_sum[31], stage4_sum[30:0]} + {1'd0, stage3_sum[31:0]} + {2'd0, stage2_sum[31:0]} + {3'd0, stage1_sum[31:0]};
        o_en_reg <= 1'd1;
    end
end

always @(*) begin
    stage1_cout = (stage1_a[0] & stage1_b[0]) | ((stage1_a[0] | stage1_b[0]) & stage1_cin[0]);
    stage2_cout = (stage2_a[0] & stage2_b[0]) | ((stage2_a[0] | stage2_b[0]) & stage2_cin[0]);
    stage3_cout = (stage3_a[0] & stage3_b[0]) | ((stage3_a[0] | stage3_b[0]) & stage3_cin[0]);
    stage4_cout = (stage4_a[0] & stage4_b[0]) | ((stage4_a[0] | stage4_b[0]) & stage4_cin[0]);
end

assign result = final_sum;
assign o_en = o_en_reg;

endmodule