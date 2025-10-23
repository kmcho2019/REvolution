module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg stage1_cout;
reg [64:0] stage2_sum;
reg stage2_cout;
reg [63:0] stage3_adda;
reg [63:0] stage3_addb;
reg stage3_i_en;

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_cout <= 1'd0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_cout <= 1'd0;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        stage1_cout <= stage1_cout;
    end
end

// Combinational logic for pipeline stage 1
reg [63:0] stage1_sum;
always @(*) begin
    {stage1_sum, stage1_cout} = stage1_adda + stage1_addb;
end

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 65'd0;
        stage2_cout <= 1'd0;
    end else begin
        stage2_sum <= {stage1_cout, stage1_sum};
        stage2_cout <= stage1_cout;
    end
end

// Pipeline stage 3
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_adda <= 64'd0;
        stage3_addb <= 64'd0;
        stage3_i_en <= 1'd0;
    end else begin
        stage3_adda <= stage1_adda;
        stage3_addb <= stage1_addb;
        stage3_i_en <= i_en;
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'd0;
    end else if (stage3_i_en) begin
        result <= stage2_sum;
        o_en <= 1'd1;
    end else begin
        result <= result;
        o_en <= 1'd0;
    end
end

endmodule