module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Register file to store partial products
reg [7:0] partial_products [0:size-1];

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Parallel partial product generation
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            partial_products[i] = {4'b0, mul_a} << i;
        end else begin
            partial_products[i] = 8'd0;
        end
    end
end

// Pipeline accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Add partial products
        stage1_reg <= partial_products[0] + partial_products[1];
        
        // Stage 2: Add remaining partial products and output final product
        stage2_reg <= stage1_reg + partial_products[2] + partial_products[3];
        
        // Output the final product
        mul_out <= stage2_reg;
    end
end

endmodule