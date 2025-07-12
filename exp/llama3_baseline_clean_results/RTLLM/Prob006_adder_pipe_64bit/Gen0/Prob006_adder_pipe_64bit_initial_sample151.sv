module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Internal signals for pipeline stages
reg    [63:0]  stage1_a;
reg    [63:0]  stage1_b;
reg    [64:0]  stage1_sum;

reg    [63:0]  stage2_a;
reg    [63:0]  stage2_b;
reg    [64:0]  stage2_sum;

reg    [1:0]   stage_cnt;
reg             stage_en;

// Synchronize input enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage_en  <= 1'b0;
    end else if (i_en) begin
        stage_en  <= 1'b1;
    end
end

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a  <= 64'd0;
        stage1_b  <= 64'd0;
    end else if (stage_en) begin
        stage1_a  <= adda;
        stage1_b  <= addb;
    end
end

// Calculate sum for stage 1
assign stage1_sum = {1'b0, stage1_a} + {1'b0, stage1_b};

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_a  <= 64'd0;
        stage2_b  <= 64'd0;
    end else if (stage_en) begin
        stage2_a  <= stage1_a;
        stage2_b  <= stage1_b;
    end
end

// Calculate sum for stage 2 (not actually needed, just for demonstration)
assign stage2_sum = {1'b0, stage2_a} + {1'b0, stage2_b};

// Output logic
assign result = stage2_sum;

// Update stage counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage_cnt <= 2'd0;
    end else if (stage_en) begin
        stage_cnt <= stage_cnt + 1;
        if (stage_cnt == 2'd2) begin
            stage_cnt <= 2'd0;
        end
    end
end

// Output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en  <= 1'b0;
    end else if (stage_cnt == 2'd1) begin
        o_en  <= 1'b1;
    end else begin
        o_en  <= 1'b0;
    end
end

endmodule