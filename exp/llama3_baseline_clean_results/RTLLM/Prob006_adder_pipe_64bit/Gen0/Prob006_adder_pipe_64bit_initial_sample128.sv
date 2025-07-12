module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal signals
reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg stage1_en;
reg [63:0] stage2_sum;
reg stage2_cout;
reg stage2_en;
reg [64:0] stage3_result;
reg stage3_en;

// Stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 1'b0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= 1'b1;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        stage1_en <= stage1_en;
    end
end

// Stage 2: Calculate sum and carry
reg [63:0] sum;
reg cout;
always @(*) begin
    {cout, sum} = stage1_a + stage1_b;
end

// Stage 2: Register sum and carry
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
        stage2_en <= 1'b0;
    end else if (stage1_en) begin
        stage2_sum <= sum;
        stage2_cout <= cout;
        stage2_en <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_cout <= stage2_cout;
        stage2_en <= stage2_en;
    end
end

// Stage 3: Calculate final result
always @(*) begin
    stage3_result = {stage2_cout, stage2_sum};
end

// Stage 3: Register final result and output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
        stage3_en <= 1'b0;
    end else if (stage2_en) begin
        result <= stage3_result;
        o_en <= 1'b1;
        stage3_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= o_en;
        stage3_en <= stage3_en;
    end
end

endmodule