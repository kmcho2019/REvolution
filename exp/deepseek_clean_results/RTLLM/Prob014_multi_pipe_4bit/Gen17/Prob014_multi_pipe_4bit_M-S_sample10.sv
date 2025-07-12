module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline registers
reg [7:0] partial_products [0:3];
reg [7:0] stage1_sum;
reg [7:0] stage2_sum;

// Generate partial products
integer i;
always @(*) begin
    for (i = 0; i < size; i = i + 1) begin
        partial_products[i] = mul_b[i] ? (mul_a << i) : 8'b0;
    end
end

// First pipeline stage: Sum of first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 8'b0;
    end else begin
        stage1_sum <= partial_products[0] + partial_products[1];
    end
end

// Second pipeline stage: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        stage2_sum <= partial_products[2] + partial_products[3];
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule