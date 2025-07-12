module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGE_BITS = 8;
    localparam NUM_STAGES = 8;

    // Pipeline registers for sum and carry between stages
    reg [STAGE_BITS-1:0] sum_pipe [0:NUM_STAGES-1];
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline registers for input operands slices and enable (only for stage 0)
    reg [STAGE_BITS-1:0] adda_slices [0:NUM_STAGES-1];
    reg [STAGE_BITS-1:0] addb_slices [0:NUM_STAGES-1];
    reg en_pipe [0:NUM_STAGES];

    integer i;

    // Slice inputs at stage 0 on i_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
                adda_slices[i] <= 0;
                addb_slices[i] <= 0;
                en_pipe[i] <= 0;
                carry_pipe[i] <= 0;
            end
            carry_pipe[NUM_STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0 input latching and enable
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_slices[i] <= adda[i*STAGE_BITS +: STAGE_BITS];
                    addb_slices[i] <= addb[i*STAGE_BITS +: STAGE_BITS];
                end
            end

            // Shift enable pipeline
            en_pipe[0] <= i_en;
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Carry in to first stage is zero
            carry_pipe[0] <= 1'b0;

            // Perform addition stage by stage on every clock
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_slices[i] + addb_slices[i] + carry_pipe[i];
                end else begin
                    // Hold previous values if no enable
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Assemble result and output enable after last stage
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry_pipe[NUM_STAGES],
                           sum_pipe[NUM_STAGES-1], sum_pipe[NUM_STAGES-2], sum_pipe[NUM_STAGES-3], sum_pipe[NUM_STAGES-4],
                           sum_pipe[NUM_STAGES-5], sum_pipe[NUM_STAGES-6], sum_pipe[NUM_STAGES-7], sum_pipe[0]};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule