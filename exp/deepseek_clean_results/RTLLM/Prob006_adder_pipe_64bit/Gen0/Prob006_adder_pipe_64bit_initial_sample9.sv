module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers for operands and carries
reg [15:0] adda_stage1, adda_stage2, adda_stage3, adda_stage4;
reg [15:0] addb_stage1, addb_stage2, addb_stage3, addb_stage4;
reg carry_stage1, carry_stage2, carry_stage3, carry_stage4;

// Intermediate sums
wire [16:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;

// Pipeline enable signals
reg en_stage1, en_stage2, en_stage3, en_stage4;

// Stage 1: Bits [15:0]
assign sum_stage1 = {1'b0, adda_stage1} + {1'b0, addb_stage1} + carry_stage1;

// Stage 2: Bits [31:16]
assign sum_stage2 = {1'b0, adda_stage2} + {1'b0, addb_stage2} + sum_stage1[16];

// Stage 3: Bits [47:32]
assign sum_stage3 = {1'b0, adda_stage3} + {1'b0, addb_stage3} + sum_stage2[16];

// Stage 4: Bits [63:48]
assign sum_stage4 = {1'b0, adda_stage4} + {1'b0, addb_stage4} + sum_stage3[16];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_stage1 <= 16'b0;
        adda_stage2 <= 16'b0;
        adda_stage3 <= 16'b0;
        adda_stage4 <= 16'b0;
        addb_stage1 <= 16'b0;
        addb_stage2 <= 16'b0;
        addb_stage3 <= 16'b0;
        addb_stage4 <= 16'b0;
        carry_stage1 <= 1'b0;
        carry_stage2 <= 1'b0;
        carry_stage3 <= 1'b0;
        carry_stage4 <= 1'b0;
        en_stage1 <= 1'b0;
        en_stage2 <= 1'b0;
        en_stage3 <= 1'b0;
        en_stage4 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        adda_stage1 <= adda[15:0];
        addb_stage1 <= addb[15:0];
        carry_stage1 <= 1'b0;
        en_stage1 <= i_en;

        // Pipeline stage 2
        adda_stage2 <= adda[31:16];
        addb_stage2 <= addb[31:16];
        carry_stage2 <= sum_stage1[16];
        en_stage2 <= en_stage1;

        // Pipeline stage 3
        adda_stage3 <= adda[47:32];
        addb_stage3 <= addb[47:32];
        carry_stage3 <= sum_stage2[16];
        en_stage3 <= en_stage2;

        // Pipeline stage 4
        adda_stage4 <= adda[63:48];
        addb_stage4 <= addb[63:48];
        carry_stage4 <= sum_stage3[16];
        en_stage4 <= en_stage3;

        // Final result assembly
        result <= {sum_stage4[16], sum_stage4[15:0], sum_stage3[15:0], 
                   sum_stage2[15:0], sum_stage1[15:0]};
        o_en <= en_stage4;
    end
end

endmodule