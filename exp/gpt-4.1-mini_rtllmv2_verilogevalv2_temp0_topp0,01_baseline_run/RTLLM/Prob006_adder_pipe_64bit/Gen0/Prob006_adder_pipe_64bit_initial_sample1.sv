module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

// Parameters for pipeline stages
// Let's split 64 bits into 4 stages of 16 bits each for balanced pipeline
localparam STAGE_NUM = 4;
localparam STAGE_WIDTH = 16;

// Pipeline registers for operands, carry, and enable signals
reg [STAGE_WIDTH-1:0] stage_adda   [0:STAGE_NUM-1];
reg [STAGE_WIDTH-1:0] stage_addb   [0:STAGE_NUM-1];
reg carry               [0:STAGE_NUM]; // carry[0] is initial carry-in (0)
reg en_pipe             [0:STAGE_NUM];

// Intermediate sums for each stage
reg [STAGE_WIDTH-1:0] stage_sum    [0:STAGE_NUM-1];

// Initialize carry-in and enable pipeline registers
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            stage_adda[i] <= 0;
            stage_addb[i] <= 0;
            stage_sum[i]  <= 0;
            carry[i]      <= 0;
            en_pipe[i]    <= 0;
        end
        carry[STAGE_NUM] <= 0;
        en_pipe[STAGE_NUM] <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0 input registers
        if (i_en) begin
            stage_adda[0] <= adda[15:0];
            stage_addb[0] <= addb[15:0];
        end else begin
            stage_adda[0] <= 0;
            stage_addb[0] <= 0;
        end
        carry[0] <= 0; // initial carry-in is zero
        en_pipe[0] <= i_en;

        // For stages 1 to STAGE_NUM-1, register inputs from previous stage
        for (i = 1; i < STAGE_NUM; i = i + 1) begin
            if (en_pipe[i-1]) begin
                stage_adda[i] <= adda[i*STAGE_WIDTH +: STAGE_WIDTH];
                stage_addb[i] <= addb[i*STAGE_WIDTH +: STAGE_WIDTH];
            end else begin
                stage_adda[i] <= 0;
                stage_addb[i] <= 0;
            end
            en_pipe[i] <= en_pipe[i-1];
        end

        // Calculate sums and carry for each stage sequentially (ripple carry)
        // We do this combinationally inside the clocked block to keep pipeline registers
        // carry[i+1] = carry out of stage i
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            {carry[i+1], stage_sum[i]} <= stage_adda[i] + stage_addb[i] + carry[i];
        end

        // Register output enable and result at last stage
        en_pipe[STAGE_NUM] <= en_pipe[STAGE_NUM-1];
        carry[STAGE_NUM] <= carry[STAGE_NUM]; // carry out from last stage

        // Assemble final result from stage sums and final carry out
        if (en_pipe[STAGE_NUM-1]) begin
            result <= {carry[STAGE_NUM], stage_sum[STAGE_NUM-1], stage_sum[STAGE_NUM-2], stage_sum[STAGE_NUM-3], stage_sum[0]};
            o_en <= 1'b1;
        end else begin
            result <= 0;
            o_en <= 1'b0;
        end
    end
end

endmodule