module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Clock gating logic
wire enable = |mul_a || |mul_b;

// Pipeline stage 1: Partial product generation
reg [7:0] pp [0:3];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i = i + 1) begin
            pp[i] <= 8'b0;
        end
    end else if (enable) begin
        pp[0] <= mul_b[0] ? {4'b0, mul_a}       : 8'b0;
        pp[1] <= mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
        pp[2] <= mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
        pp[3] <= mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;
    end
end

// Pipeline stage 2: Accumulation and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else if (enable) begin
        mul_out <= pp[0] + pp[1] + pp[2] + pp[3];
    end
end

endmodule