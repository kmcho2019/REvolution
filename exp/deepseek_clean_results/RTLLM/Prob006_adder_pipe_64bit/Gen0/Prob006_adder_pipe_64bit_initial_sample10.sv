module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [15:0] adda_stage1, addb_stage1;
reg [15:0] adda_stage2, addb_stage2;
reg [15:0] adda_stage3, addb_stage3;
reg [15:0] adda_stage4, addb_stage4;

reg [16:0] sum_stage1;  // 16-bit sum + carry
reg [16:0] sum_stage2;
reg [16:0] sum_stage3;

reg carry_stage1;
reg carry_stage2;
reg carry_stage3;

// Pipeline enable signals
reg en_stage1;
reg en_stage2;
reg en_stage3;
reg en_stage4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_stage1 <= 16'b0;
        addb_stage1 <= 16'b0;
        adda_stage2 <= 16'b0;
        addb_stage2 <= 16'b0;
        adda_stage3 <= 16'b0;
        addb_stage3 <= 16'b0;
        adda_stage4 <= 16'b0;
        addb_stage4 <= 16'b0;
        
        sum_stage1 <= 17'b0;
        sum_stage2 <= 17'b0;
        sum_stage3 <= 17'b0;
        
        carry_stage1 <= 1'b0;
        carry_stage2 <= 1'b0;
        carry_stage3 <= 1'b0;
        
        en_stage1 <= 1'b0;
        en_stage2 <= 1'b0;
        en_stage3 <= 1'b0;
        en_stage4 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process bits [15:0]
        {carry_stage1, sum_stage1[15:0]} <= adda[15:0] + addb[15:0];
        en_stage1 <= i_en;
        adda_stage1 <= adda[15:0];
        addb_stage1 <= addb[15:0];
        
        // Stage 2: Process bits [31:16]
        {carry_stage2, sum_stage2[15:0]} <= adda[31:16] + addb[31:16] + carry_stage1;
        en_stage2 <= en_stage1;
        adda_stage2 <= adda[31:16];
        addb_stage2 <= addb[31:16];
        sum_stage1[16] <= carry_stage1;
        
        // Stage 3: Process bits [47:32]
        {carry_stage3, sum_stage3[15:0]} <= adda[47:32] + addb[47:32] + carry_stage2;
        en_stage3 <= en_stage2;
        adda_stage3 <= adda[47:32];
        addb_stage3 <= addb[47:32];
        sum_stage2[16] <= carry_stage2;
        
        // Stage 4: Process bits [63:48]
        en_stage4 <= en_stage3;
        adda_stage4 <= adda[63:48];
        addb_stage4 <= addb[63:48];
        sum_stage3[16] <= carry_stage3;
        
        // Final output assembly
        if (en_stage4) begin
            result <= {1'b0, adda_stage4 + addb_stage4 + carry_stage3, 
                      sum_stage3[15:0], sum_stage2[15:0], sum_stage1[15:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule