module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [size-1:0] stage1_a, stage1_b;
reg [2*size-1:0] stage1_pp;
reg [size-1:0] stage2_b;
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_a <= 0;
        stage1_b <= 0;
        stage1_pp <= 0;
        stage2_b <= 0;
        mul_out <= 0;
    end else begin
        // Stage 1: Process LSBs (bits 0-1)
        stage1_a <= mul_a;
        stage1_b <= mul_b;
        stage1_pp <= (mul_b[0] ? ext_a : 0) + 
                    (mul_b[1] ? ext_a << 1 : 0);
        
        // Stage 2: Process MSBs (bits 2-3) and combine
        stage2_b <= stage1_b;
        mul_out <= stage1_pp + 
                   (stage1_b[2] ? { {2{1'b0}}, stage1_a, 2'b0 } : 0) +
                   (stage1_b[3] ? { {1'b0}, stage1_a, 3'b0 } : 0);
    end
end

endmodule