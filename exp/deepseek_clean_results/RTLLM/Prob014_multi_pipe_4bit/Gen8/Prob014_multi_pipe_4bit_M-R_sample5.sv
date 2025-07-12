module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline Stage 1: Partial Product Generation
wire [7:0] partial_products [0:3];
reg [7:0] partial_products_reg [0:3];
reg [3:0] b_reg;

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_GEN
        assign partial_products[i] = mul_b[i] ? ({4'b0, mul_a} << i) : 8'b0;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer j = 0; j < size; j = j + 1) begin
            partial_products_reg[j] <= 8'b0;
        end
        b_reg <= 4'b0;
    end else begin
        for (integer j = 0; j < size; j = j + 1) begin
            partial_products_reg[j] <= partial_products[j];
        end
        b_reg <= mul_b;
    end
end

// Pipeline Stage 2: Accumulation
reg [7:0] sum_stage1 [0:1];
reg [7:0] sum_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1[0] <= 8'b0;
        sum_stage1[1] <= 8'b0;
        sum_stage2 <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First level of adder tree
        sum_stage1[0] <= partial_products_reg[0] + partial_products_reg[1];
        sum_stage1[1] <= partial_products_reg[2] + partial_products_reg[3];
        
        // Second level of adder tree
        sum_stage2 <= sum_stage1[0] + sum_stage1[1];
        
        // Final output register
        mul_out <= sum_stage2;
    end
end

endmodule