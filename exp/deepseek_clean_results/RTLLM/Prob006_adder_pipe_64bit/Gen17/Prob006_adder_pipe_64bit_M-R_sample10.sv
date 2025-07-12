module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

parameter BLOCK_WIDTH = 16;
localparam NUM_BLOCKS = 64/BLOCK_WIDTH;
localparam PIPELINE_DEPTH = NUM_BLOCKS;

// Pipeline registers
reg [63:0] a_stage0, a_stage1, a_stage2, a_stage3;
reg [63:0] b_stage0, b_stage1, b_stage2, b_stage3;
reg carry_stage0, carry_stage1, carry_stage2, carry_stage3;
reg [PIPELINE_DEPTH:0] en_shift_reg;

// Block sum computations (combinational)
wire [BLOCK_WIDTH:0] sum0_block0 = {1'b0, a_stage0[0 +: BLOCK_WIDTH]} + {1'b0, b_stage0[0 +: BLOCK_WIDTH]};
wire [BLOCK_WIDTH:0] sum1_block0 = sum0_block0 + 1'b1;

wire [BLOCK_WIDTH:0] sum0_block1 = {1'b0, a_stage1[BLOCK_WIDTH +: BLOCK_WIDTH]} + {1'b0, b_stage1[BLOCK_WIDTH +: BLOCK_WIDTH]};
wire [BLOCK_WIDTH:0] sum1_block1 = sum0_block1 + 1'b1;

wire [BLOCK_WIDTH:0] sum0_block2 = {1'b0, a_stage2[2*BLOCK_WIDTH +: BLOCK_WIDTH]} + {1'b0, b_stage2[2*BLOCK_WIDTH +: BLOCK_WIDTH]};
wire [BLOCK_WIDTH:0] sum1_block2 = sum0_block2 + 1'b1;

wire [BLOCK_WIDTH:0] sum0_block3 = {1'b0, a_stage3[3*BLOCK_WIDTH +: BLOCK_WIDTH]} + {1'b0, b_stage3[3*BLOCK_WIDTH +: BLOCK_WIDTH]};
wire [BLOCK_WIDTH:0] sum1_block3 = sum0_block3 + 1'b1;

// Selected sums based on carry
wire [BLOCK_WIDTH-1:0] selected_sum0 = carry_stage0 ? sum1_block0[BLOCK_WIDTH-1:0] : sum0_block0[BLOCK_WIDTH-1:0];
wire [BLOCK_WIDTH-1:0] selected_sum1 = carry_stage1 ? sum1_block1[BLOCK_WIDTH-1:0] : sum0_block1[BLOCK_WIDTH-1:0];
wire [BLOCK_WIDTH-1:0] selected_sum2 = carry_stage2 ? sum1_block2[BLOCK_WIDTH-1:0] : sum0_block2[BLOCK_WIDTH-1:0];
wire [BLOCK_WIDTH-1:0] selected_sum3 = carry_stage3 ? sum1_block3[BLOCK_WIDTH-1:0] : sum0_block3[BLOCK_WIDTH-1:0];

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        a_stage0 <= 64'b0;
        a_stage1 <= 64'b0;
        a_stage2 <= 64'b0;
        a_stage3 <= 64'b0;
        b_stage0 <= 64'b0;
        b_stage1 <= 64'b0;
        b_stage2 <= 64'b0;
        b_stage3 <= 64'b0;
        carry_stage0 <= 1'b0;
        carry_stage1 <= 1'b0;
        carry_stage2 <= 1'b0;
        carry_stage3 <= 1'b0;
        en_shift_reg <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_shift_reg <= {en_shift_reg[PIPELINE_DEPTH-1:0], i_en};
        
        // Stage 0: Register inputs
        a_stage0 <= adda;
        b_stage0 <= addb;
        carry_stage0 <= 1'b0;  // Initial carry-in
        
        // Stage 1: First block processed
        a_stage1 <= a_stage0;
        b_stage1 <= b_stage0;
        carry_stage1 <= sum0_block0[BLOCK_WIDTH];
        
        // Stage 2: Second block processed
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        carry_stage2 <= carry_stage1 ? sum1_block1[BLOCK_WIDTH] : sum0_block1[BLOCK_WIDTH];
        
        // Stage 3: Third block processed
        a_stage3 <= a_stage2;
        b_stage3 <= b_stage2;
        carry_stage3 <= carry_stage2 ? sum1_block2[BLOCK_WIDTH] : sum0_block2[BLOCK_WIDTH];
        
        // Output stage
        if (en_shift_reg[PIPELINE_DEPTH]) begin
            // Assemble final result
            result[64] <= carry_stage3 ? sum1_block3[BLOCK_WIDTH] : sum0_block3[BLOCK_WIDTH];
            result[0 +: BLOCK_WIDTH] <= selected_sum0;
            result[BLOCK_WIDTH +: BLOCK_WIDTH] <= selected_sum1;
            result[2*BLOCK_WIDTH +: BLOCK_WIDTH] <= selected_sum2;
            result[3*BLOCK_WIDTH +: BLOCK_WIDTH] <= selected_sum3;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule