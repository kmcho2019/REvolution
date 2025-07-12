module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline stage 1: Partial product generation
reg [7:0] pp0, pp1, pp2, pp3;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 8'b0;
        pp1 <= 8'b0;
        pp2 <= 8'b0;
        pp3 <= 8'b0;
    end else begin
        pp0 <= mul_b[0] ? {4'b0, mul_a}       : 8'b0;
        pp1 <= mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
        pp2 <= mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
        pp3 <= mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;
    end
end

// Pipeline stage 2: Accumulation
reg [7:0] sum_stage1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 8'b0;
    end else begin
        sum_stage1 <= pp0 + pp1 + pp2 + pp3;
    end
end

// Final output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_stage1;
    end
end

endmodule