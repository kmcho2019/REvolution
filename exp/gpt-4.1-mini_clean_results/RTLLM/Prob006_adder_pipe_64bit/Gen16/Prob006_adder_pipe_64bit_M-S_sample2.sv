module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGE_BITS = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for operands slices
    reg [STAGE_BITS-1:0] adda_pipe [0:NUM_STAGES-1];
    reg [STAGE_BITS-1:0] addb_pipe [0:NUM_STAGES-1];

    // Pipeline registers for sums and carry outs
    reg [STAGE_BITS-1:0] sum_pipe [0:NUM_STAGES-1];
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline register for output enable
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i] <= 0;
            end
            carry_pipe[NUM_STAGES] <= 0;
            en_pipe <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0: latch operands slices when i_en
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[i*STAGE_BITS +: STAGE_BITS];
                    addb_pipe[i] <= addb[i*STAGE_BITS +: STAGE_BITS];
                end
            end

            // Carry in to stage 0 is zero
            carry_pipe[0] <= 1'b0;

            // Perform additions stage by stage if respective enable is asserted
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Assemble final result when last stage output is valid
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry_pipe[NUM_STAGES],
                           sum_pipe[NUM_STAGES-1], sum_pipe[NUM_STAGES-2],
                           sum_pipe[NUM_STAGES-3], sum_pipe[0]};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule