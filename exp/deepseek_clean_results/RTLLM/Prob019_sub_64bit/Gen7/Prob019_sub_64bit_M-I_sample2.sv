module sub_64bit (
    input clk,
    input reset,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg [63:0] A_reg, B_reg;
    reg [63:0] stage1_result;
    reg [63:0] stage2_result;
    reg [63:0] stage3_result;
    reg stage1_ovf, stage2_ovf, stage3_ovf;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg <= 64'b0;
            B_reg <= 64'b0;
            stage1_result <= 64'b0;
            stage2_result <= 64'b0;
            stage3_result <= 64'b0;
            stage1_ovf <= 1'b0;
            stage2_ovf <= 1'b0;
            stage3_ovf <= 1'b0;
            result <= 64'b0;
            overflow <= 1'b0;
        end else begin
            // Stage 0: Input registration
            A_reg <= A;
            B_reg <= B;
            
            // Stage 1: Lower 16 bits
            stage1_result[15:0] <= A_reg[15:0] - B_reg[15:0];
            stage1_result[63:16] <= A_reg[63:16] - B_reg[63:16]; // Carry propagates
            stage1_ovf <= (A_reg[63] != B_reg[63]) && (A_reg[63] != (A_reg - B_reg)[63]);
            
            // Stage 2: Next 16 bits
            stage2_result <= stage1_result;
            stage2_ovf <= stage1_ovf;
            
            // Stage 3: Next 16 bits
            stage3_result <= stage2_result;
            stage3_ovf <= stage2_ovf;
            
            // Stage 4: Output
            result <= stage3_result;
            overflow <= stage3_ovf;
        end
    end

endmodule