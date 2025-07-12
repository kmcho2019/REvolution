module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters for stage width and number of stages
    localparam STAGE_WIDTH = 8;
    localparam NUM_STAGES = 64 / STAGE_WIDTH;

    // Pipeline registers for inputs and enable to synchronize
    reg [63:0] adda_pipe [0:NUM_STAGES];
    reg [63:0] addb_pipe [0:NUM_STAGES];
    reg        en_pipe   [0:NUM_STAGES];

    // Sum registers for each stage (8 bits each)
    reg [STAGE_WIDTH-1:0] sum_pipe [0:NUM_STAGES-1];

    // Carry registers between stages (1 bit each)
    reg carry_pipe [0:NUM_STAGES];

    integer i;

    // At stage 0, latch inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'b0;
                addb_pipe[i] <= 64'b0;
                en_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
                if (i < NUM_STAGES) sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch inputs and enable
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            en_pipe[0] <= i_en;

            // Carry-in for stage 0 is always 0
            carry_pipe[0] <= 1'b0;

            // For each pipeline stage, perform 8-bit addition with carry-in from previous stage
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i][i*STAGE_WIDTH +: STAGE_WIDTH] +
                                                     addb_pipe[i][i*STAGE_WIDTH +: STAGE_WIDTH] +
                                                     carry_pipe[i];
                end else begin
                    // No valid operation, keep previous values or clear sums
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Shift pipeline registers for inputs and enable signals for next stage
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                en_pipe[i]   <= en_pipe[i-1];
            end

            // Assemble the full result when output is valid
            // The pipeline latency is NUM_STAGES clocks
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sums from all stages plus final carry out
                result <= {carry_pipe[NUM_STAGES], 
                           sum_pipe[NUM_STAGES-1], sum_pipe[NUM_STAGES-2], sum_pipe[NUM_STAGES-3], sum_pipe[NUM_STAGES-4],
                           sum_pipe[NUM_STAGES-5], sum_pipe[NUM_STAGES-6], sum_pipe[NUM_STAGES-7], sum_pipe[0]};
            end else begin
                // If output not valid, hold previous result or clear
                result <= result;
            end

            // Output enable delayed along pipeline
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule