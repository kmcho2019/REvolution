module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] stage1, stage2;

// First pipeline stage: pp0 + pp1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 0;
    end else begin
        stage1 <= (mul_b[0] ? mul_a : 0) + 
                 (mul_b[1] ? mul_a << 1 : 0);
    end
end

// Second pipeline stage: pp2 + pp3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2 <= 0;
    end else begin
        stage2 <= (mul_b[2] ? mul_a << 2 : 0) + 
                 (mul_b[3] ? mul_a << 3 : 0);
    end
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= stage1 + stage2;
    end
end

endmodule