module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [size-1:0] mul_a,  // input signal representing the multiplicand
    input [size-1:0] mul_b,  // input signal representing the multiplier
    output reg [2*size-1:0] mul_out  // product output signal
);

// Pipeline registers
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Pipeline accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage1_reg <= {size{1'b0}} + mul_a;
        for (int i = 1; i < size; i++) begin
            if (mul_b[i]) begin
                stage1_reg <= stage1_reg + ({size{1'b0}} + mul_a) << i;
            end
        end
        stage2_reg <= stage1_reg;
        mul_out <= stage2_reg;
    end
end

endmodule