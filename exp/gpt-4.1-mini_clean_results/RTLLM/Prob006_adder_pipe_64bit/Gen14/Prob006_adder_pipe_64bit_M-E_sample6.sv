module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Number of pipeline stages and stage width
    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for partial sums and carry outs
    reg [STAGE_WIDTH-1:0] sum_stage [0:NUM_STAGES-1];
    reg carry_stage [0:NUM_STAGES]; // carry_stage[0] is carry_in for stage 0

    // Pipeline registers for input operands slices and enable signals
    reg [STAGE_WIDTH-1:0] adda_pipe [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_pipe [0:NUM_STAGES-1];
    reg en_pipe [0:NUM_STAGES]; // enables for each pipeline stage

    integer i;

    // Pipeline operation on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum_stage[i]   <= 0;
                adda_pipe[i]   <= 0;
                addb_pipe[i]   <= 0;
                carry_stage[i] <= 0;
                en_pipe[i]     <= 0;
            end
            carry_stage[NUM_STAGES] <= 0;
            en_pipe[NUM_STAGES]     <= 0;
            result                 <= 0;
            o_en                   <= 0;
        end else begin
            // Stage 0 input registers and carry in
            adda_pipe[0]   <= adda[15:0];
            addb_pipe[0]   <= addb[15:0];
            carry_stage[0] <= 1'b0;      // carry in is zero at first stage
            en_pipe[0]     <= i_en;

            // Subsequent stages take their operand slices and enable signals delayed by stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STAGE_WIDTH +: STAGE_WIDTH];
                addb_pipe[i] <= addb[i*STAGE_WIDTH +: STAGE_WIDTH];
                en_pipe[i]   <= en_pipe[i-1];
                carry_stage[i] <= carry_stage[i]; // will be updated after sum calculation below
            end
            en_pipe[NUM_STAGES] <= en_pipe[NUM_STAGES-1];

            // Compute sum and carry for each stage in a pipeline fashion
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                {carry_stage[i+1], sum_stage[i]} <= adda_pipe[i] + addb_pipe[i] + carry_stage[i];
            end

            // Combine partial sums and final carry out to form full result
            result <= {carry_stage[NUM_STAGES], sum_stage[NUM_STAGES-1],
                       sum_stage[NUM_STAGES-2], sum_stage[NUM_STAGES-3], sum_stage[0]};
            // Note: sum_stage[0] is lowest bits, placed at result[15:0]; but for correctness, assign bits correctly:
            // Assign the bits explicitly for clarity

            // Rearrange result correctly:
            result[15:0]   <= sum_stage[0];
            result[31:16]  <= sum_stage[1];
            result[47:32]  <= sum_stage[2];
            result[63:48]  <= sum_stage[3];
            result[64]     <= carry_stage[NUM_STAGES];

            // Output enable reflects that the data is ready after last stage
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule