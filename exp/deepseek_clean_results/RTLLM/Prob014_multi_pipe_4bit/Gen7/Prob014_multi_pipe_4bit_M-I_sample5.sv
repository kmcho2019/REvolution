module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline stage 1: Partial product generation
reg [7:0] partial_products [0:3];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 4; i = i + 1) begin
            partial_products[i] <= 8'b0;
        end
    end else begin
        for (i = 0; i < 4; i = i + 1) begin
            partial_products[i] <= (mul_b[i] ? {4'b0, mul_a} << i : 8'b0);
        end
    end
end

// Pipeline stage 2: Summation of partial products
reg [7:0] sum_stage1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        sum_stage1 <= partial_products[0] + partial_products[1];
        mul_out <= sum_stage1 + partial_products[2] + partial_products[3];
    end
end

endmodule