module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg      o_en
);

// Parameters
localparam STAGE_BITS = 8;         // Number of bits per pipeline stage
localparam STAGE_NUM  = 64 / STAGE_BITS; // Number of pipeline stages

// Pipeline registers for operands and carry
reg [STAGE_BITS-1:0] adda_pipe [0:STAGE_NUM-1];
reg [STAGE_BITS-1:0] addb_pipe [0:STAGE_NUM-1];
reg                  carry_pipe[0:STAGE_NUM]; // carry_pipe[0] is carry-in to stage 0 (always 0)

// Pipeline registers for enable signal
reg [STAGE_NUM:0] en_pipe;

// Partial sum registers
reg [STAGE_BITS-1:0] sum_pipe [0:STAGE_NUM-1];

// Intermediate carry signals from each stage addition
reg carry_out_stage [0:STAGE_NUM-1];

integer i;

// Split operands and pipeline them
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            adda_pipe[i] <= 0;
            addb_pipe[i] <= 0;
            sum_pipe[i]  <= 0;
            carry_out_stage[i] <= 0;
        end
        for (i = 0; i <= STAGE_NUM; i = i + 1) begin
            carry_pipe[i] <= 0;
            en_pipe[i]    <= 0;
        end
        result <= 0;
        o_en <= 0;
    end else begin
        // Pipe input operands
        // Stage 0 gets new inputs when i_en=1, otherwise operands can be held or zeroed
        if (i_en) begin
            for (i = 0; i < STAGE_NUM; i = i + 1) begin
                adda_pipe[i] <= adda[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                addb_pipe[i] <= addb[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
            end
        end else begin
            // Hold previous values if i_en is low (optional)
            for (i = 0; i < STAGE_NUM; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i];
                addb_pipe[i] <= addb_pipe[i];
            end
        end

        // Pipeline carry chain
        carry_pipe[0] <= 0; // carry-in to first stage always 0
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            // Each stage adds its bits + carry in from previous stage
            {carry_out_stage[i], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            carry_pipe[i+1] <= carry_out_stage[i];
        end

        // Pipeline enable signal along with data through the stages
        en_pipe[0] <= i_en;
        for (i = 0; i < STAGE_NUM; i = i + 1) begin
            en_pipe[i+1] <= en_pipe[i];
        end

        // Concatenate partial sums and the final carry out as output
        // Wait until last stage's data is valid (after STAGE_NUM cycles)
        if (en_pipe[STAGE_NUM]) begin
            result <= {carry_pipe[STAGE_NUM], sum_pipe[STAGE_NUM-1]};
            // concatenate sum_pipe from stage 0 to stage STAGE_NUM-2 in order
            // We do it via shifting and ORing
            for (i = STAGE_NUM-2; i >= 0; i = i - 1) begin
                result <= {result[64 - STAGE_BITS*i - 1 : 0], sum_pipe[i]};
            end
        end else begin
            result <= result; // hold last result
        end

        // Output enable signal reflects when result is valid
        o_en <= en_pipe[STAGE_NUM];
    end
end

endmodule