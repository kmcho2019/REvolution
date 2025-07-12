module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers - fixed 64-bit width
reg [63:0] a_stage1, a_stage2;
reg [63:0] b_stage1, b_stage2;
reg carry_stage1, carry_stage2;
reg en_stage1, en_stage2;

// Stage 1: Lower 32-bit addition
wire [32:0] sum_stage1 = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

// Stage 2: Upper 32-bit addition with carry
wire [32:0] sum_stage2 = {1'b0, a_stage1[63:32]} + {1'b0, b_stage1[63:32]} + carry_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_stage1 <= 64'b0;
        b_stage1 <= 64'b0;
        carry_stage1 <= 1'b0;
        en_stage1 <= 1'b0;
        
        a_stage2 <= 64'b0;
        b_stage2 <= 64'b0;
        carry_stage2 <= 1'b0;
        en_stage2 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        a_stage1 <= adda;
        b_stage1 <= addb;
        carry_stage1 <= sum_stage1[32];
        en_stage1 <= i_en;
        
        // Pipeline stage 2
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        carry_stage2 <= sum_stage2[32];
        en_stage2 <= en_stage1;
        
        // Final output assembly
        result <= {sum_stage2[32], sum_stage2[31:0], sum_stage1[31:0]};
        o_en <= en_stage2;
    end
end

endmodule