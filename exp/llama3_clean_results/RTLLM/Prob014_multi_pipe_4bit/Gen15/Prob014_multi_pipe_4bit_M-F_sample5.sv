module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;
reg [2*size-1:0] stage3_reg;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        stage3_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // Stage 1: Partial product generation
        if (clk) begin
            for (int i = 0; i < size; i++) begin
                if (mul_b[i]) begin
                    stage1_reg <= {mul_a, {size{1'b0}}} << i;
                end else begin
                    stage1_reg <= {2*size{1'b0}};
                end
            end
        end
        
        // Stage 2: Accumulation
        stage2_reg <= stage1_reg + stage2_reg;
        
        // Stage 3: Final product calculation
        stage3_reg <= stage2_reg;
        mul_out <= stage3_reg;
    end
end

// Clock gating
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        stage3_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        if (clk) begin
            stage1_reg <= stage1_reg;
            stage2_reg <= stage2_reg;
            stage3_reg <= stage3_reg;
            mul_out <= mul_out;
        end
    end
end

endmodule