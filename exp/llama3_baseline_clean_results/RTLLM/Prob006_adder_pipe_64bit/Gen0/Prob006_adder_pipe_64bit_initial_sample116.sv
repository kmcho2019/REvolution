module adder_pipe_64bit (
    input            clk,
    input            rst_n,
    input            i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output     [64:0] result,
    output           o_en
);

reg [63:0]          stage1_sum;
reg [63:0]          stage1_adda;
reg [63:0]          stage1_addb;
reg                 stage1_cout;
reg                 stage1_i_en;

reg [63:0]          stage2_sum;
reg                 stage2_cout;
reg                 stage2_i_en;

reg [64:0]          stage3_sum;
reg                 stage3_i_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= 1'b1;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        stage1_i_en <= stage1_i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= 64'd0;
        stage1_cout <= 1'b0;
        stage2_i_en <= 1'b0;
    end else if (stage1_i_en) begin
        {stage1_cout, stage1_sum} <= stage1_adda + stage1_addb;
        stage2_i_en <= 1'b1;
    end else begin
        stage1_sum <= stage1_sum;
        stage1_cout <= stage1_cout;
        stage2_i_en <= stage2_i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
        stage3_i_en <= 1'b0;
    end else if (stage2_i_en) begin
        {stage2_cout, stage2_sum} <= stage1_sum + {63'd0, stage1_cout};
        stage3_i_en <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_cout <= stage2_cout;
        stage3_i_en <= stage3_i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum <= 65'd0;
        stage3_i_en <= 1'b0;
        o_en <= 1'b0;
    end else if (stage3_i_en) begin
        stage3_sum <= {stage2_cout, stage2_sum};
        stage3_i_en <= 1'b1;
        o_en <= 1'b1;
    end else begin
        stage3_sum <= stage3_sum;
        stage3_i_en <= stage3_i_en;
        o_en <= 1'b0;
    end
end

assign result = stage3_sum;

endmodule