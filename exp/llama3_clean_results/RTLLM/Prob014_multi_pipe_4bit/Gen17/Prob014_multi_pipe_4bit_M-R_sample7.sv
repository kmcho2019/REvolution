module multi_pipe_4bit #(
    parameter size =)(
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
        stage1_reg <= (mul_b[0]) ? {mul_a, {size{1'b0}}} : {2*size{1'b0}};
        
        // Stage 2: Accumulation
        if (mul_b[1]) begin
            stage2_reg <= stage1_reg + {mul_a, {size-1{1'b0}}};
        end else if (mul_b[0]) begin
            stage2_reg <= stage1_reg;
        end else begin
            stage2_reg <= {2*size{1'b0}};
        end
        
        // Stage 3: Final product calculation
        if (mul_b[2]) begin
            stage3_reg <= stage2_reg + {mul_a, {size-2{1'b0}}};
        end else if (mul_b[1]) begin
            stage3_reg <= stage2_reg;
        end else if (mul_b[0]) begin
            stage3_reg <= stage1_reg;
        end else begin
            stage3_reg <= {2*size{1'b0}};
        end
        
        // Output
        if (mul_b[3]) begin
            mul_out <= stage3_reg + {mul_a, {size-3{1'b0}}};
        end else if (mul_b[2]) begin
            mul_out <= stage3_reg;
        end else if (mul_b[1]) begin
            mul_out <= stage2_reg;
        end else if (mul_b[0]) begin
            mul_out <= stage1_reg;
        end else begin
            mul_out <= {2*size{1'b0}};
        end
    end
end

endmodule