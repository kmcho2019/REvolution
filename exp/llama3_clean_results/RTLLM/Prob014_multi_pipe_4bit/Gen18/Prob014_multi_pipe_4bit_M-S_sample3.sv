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

// Multiplication operation
reg [7:0] product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline registers
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
        product <= 8'd0;
    end else begin
        // Stage 1: Initialize product
        if (stage1_reg == 8'd0) begin
            stage1_reg <= {4'b0, mul_a};
            product <= 8'd0;
        end else begin
            // Stage 2: Multiply and accumulate
            if (mul_b[0] == 1'b1) begin
                product <= product + stage1_reg;
            end
            // Shift multiplicand for next iteration
            stage1_reg <= stage1_reg << 1;
            // Update multiplier for next iteration
            mul_b <= mul_b >> 1;
            // Output final product after all iterations
            if (mul_b == 4'd0) begin
                mul_out <= product;
            end
        end
    end
end

endmodule