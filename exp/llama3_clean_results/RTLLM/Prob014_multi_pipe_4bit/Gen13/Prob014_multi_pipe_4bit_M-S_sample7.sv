module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Generate partial products and add them
        stage1_reg <= 8'd0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                stage1_reg <= stage1_reg + ({4'b0, mul_a} << i);
            end
        end
        
        // Stage 2: Add remaining partial products and output final product
        stage2_reg <= stage1_reg;
        
        // Output the final product
        mul_out <= stage2_reg;
    end
end

endmodule