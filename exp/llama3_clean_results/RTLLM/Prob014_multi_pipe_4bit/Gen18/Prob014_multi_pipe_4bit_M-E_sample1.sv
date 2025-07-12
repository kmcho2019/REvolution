module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Pipelined multiplier array
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;
reg [7:0] stage3_reg;
reg [7:0] stage4_reg;

// Pipeline logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        stage3_reg <= 8'd0;
        stage4_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Multiply bit 0
        stage1_reg <= (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
        
        // Stage 2: Multiply bit 1 and add to stage 1 result
        stage2_reg <= stage1_reg + ((mul_b[1] == 1'b1) ? {4'b0, mul_a} << 1 : 8'd0);
        
        // Stage 3: Multiply bit 2 and add to stage 2 result
        stage3_reg <= stage2_reg + ((mul_b[2] == 1'b1) ? {4'b0, mul_a} << 2 : 8'd0);
        
        // Stage 4: Multiply bit 3 and add to stage 3 result
        stage4_reg <= stage3_reg + ((mul_b[3] == 1'b1) ? {4'b0, mul_a} << 3 : 8'd0);
        
        // Output the final product
        mul_out <= stage4_reg;
    end
end

endmodule