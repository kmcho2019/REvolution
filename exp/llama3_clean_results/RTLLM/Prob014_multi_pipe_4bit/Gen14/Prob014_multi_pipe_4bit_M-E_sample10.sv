module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Registers to store partial products
reg [7:0] pp0, pp1, pp2, pp3;

// Registers for pipeline stages
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Generate partial products
always @(*) begin
    pp0 = (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
    pp1 = (mul_b[1] == 1'b1) ? ({4'b0, mul_a} << 1) : 8'd0;
    pp2 = (mul_b[2] == 1'b1) ? ({4'b0, mul_a} << 2) : 8'd0;
    pp3 = (mul_b[3] == 1'b1) ? ({4'b0, mul_a} << 3) : 8'd0;
end

// Pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline stages
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Add partial products
        stage1_reg <= pp0 + pp1;
        
        // Stage 2: Add remaining partial products and output final product
        stage2_reg <= stage1_reg + pp2 + pp3;
        
        // Output the final product
        mul_out <= stage2_reg;
    end
end

endmodule