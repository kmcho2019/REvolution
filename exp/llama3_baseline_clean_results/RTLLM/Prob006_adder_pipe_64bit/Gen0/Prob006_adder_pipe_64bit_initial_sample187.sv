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
reg [63:0] stage2_sum, stage2_cout;
reg [63:0] stage3_sum, stage3_cout;
reg [64:0] stage4_sum;
reg i_en_pipe1, i_en_pipe2, i_en_pipe3;

// Stage 1: Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        i_en_pipe1 <= 1'b0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        i_en_pipe1 <= 1'b1;
    end
end

// Stage 2: Full adder for bits 0-31
reg [31:0] sum1, cout1;
reg [31:0] sum2, cout2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 64'd0;
        i_en_pipe2 <= 1'b0;
    end else if (i_en_pipe1) begin
        {cout1, sum1} = stage1_a[31:0] + stage1_b[31:0];
        {cout2, sum2} = stage1_a[63:32] + stage1_b[63:32] + {{31{cout1[31]}}, cout1[31]};
        stage2_sum <= {sum2, sum1};
        stage2_cout <= {{31{cout2[31]}}, cout2[31]};
        i_en_pipe2 <= 1'b1;
    end
end

// Stage 3: Carry propagation
reg [63:0] stage3_temp;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum <= 64'd0;
        stage3_cout <= 64'd0;
        i_en_pipe3 <= 1'b0;
    end else if (i_en_pipe2) begin
        stage3_temp <= stage2_sum + {{64{stage2_cout[63]}}, stage2_cout[63]};
        stage3_sum <= stage3_temp[63:0];
        stage3_cout <= stage3_temp[64];
        i_en_pipe3 <= 1'b1;
    end
end

// Stage 4: Output register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage4_sum <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_pipe3) begin
        stage4_sum <= {stage3_cout, stage3_sum};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

assign result = stage4_sum;

endmodule