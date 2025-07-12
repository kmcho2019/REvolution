module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_stage1, b_stage1;
reg [32:0] sum_low;  // 32 bits + carry
reg en_stage1;
reg [31:0] sum_high;
reg en_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_stage1 <= 64'b0;
        b_stage1 <= 64'b0;
        sum_low <= 33'b0;
        en_stage1 <= 1'b0;
        sum_high <= 32'b0;
        en_stage2 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process lower 32 bits
        a_stage1 <= adda;
        b_stage1 <= addb;
        sum_low <= {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
        en_stage1 <= i_en;

        // Stage 2: Process upper 32 bits with carry from stage 1
        sum_high <= a_stage1[63:32] + b_stage1[63:32] + sum_low[32];
        en_stage2 <= en_stage1;

        // Output assembly
        if (en_stage2) begin
            result <= {sum_high + sum_low[32], sum_high, sum_low[31:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule