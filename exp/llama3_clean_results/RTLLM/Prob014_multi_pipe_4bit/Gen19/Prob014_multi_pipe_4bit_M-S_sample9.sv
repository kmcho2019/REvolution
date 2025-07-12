module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Pipeline accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Add partial products
        stage1_reg <= (mul_b[0] ? {4'b0, mul_a} : 8'd0) + (mul_b[1] ? {4'b0, mul_a} << 1 : 8'd0);
        
        // Stage 2: Add remaining partial products and output final product
        stage2_reg <= stage1_reg + (mul_b[2] ? {4'b0, mul_a} << 2 : 8'd0) + (mul_b[3] ? {4'b0, mul_a} << 3 : 8'd0);
        
        // Output the final product
        mul_out <= stage2_reg;
    end
end

endmodule