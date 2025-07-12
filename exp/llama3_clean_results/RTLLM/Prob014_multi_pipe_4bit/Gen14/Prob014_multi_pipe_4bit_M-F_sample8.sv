module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product_reg [size-1:0];
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // Stage 1: Partial product generation
        if (clk) begin
            for (int i = 0; i < size; i++) begin
                if (mul_b[i]) begin
                    partial_product_reg[i] <= {mul_a, {size{1'b0}}} << i;
                end else begin
                    partial_product_reg[i] <= {2*size{1'b0}};
                end
            end
            stage1_reg <= {2*size{1'b0}};
            for (int i = 0; i < size; i++) begin
                stage1_reg <= stage1_reg + partial_product_reg[i];
            end
        end
        
        // Stage 2: Accumulation and final product calculation
        stage2_reg <= stage1_reg;
        mul_out <= stage2_reg;
    end
end

endmodule