module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Number of pipeline stages
    localparam STAGES = 8;
    localparam BITS_PER_STAGE = 8;

    // Registers to hold each stage's operands
    reg [BITS_PER_STAGE-1:0] stageA [0:STAGES-1];
    reg [BITS_PER_STAGE-1:0] stageB [0:STAGES-1];

    // Registers to hold sum output for each stage (8 bits)
    reg [BITS_PER_STAGE-1:0] stageSum [0:STAGES-1];

    // Carry registers between stages: carry_in for stage 0 is 0
    reg carry [0:STAGES];

    // Pipeline registers to delay i_en to o_en
    reg [STAGES-1:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all stage registers, carries, sums, enables, output
            for (i = 0; i < STAGES; i = i + 1) begin
                stageA[i] <= {BITS_PER_STAGE{1'b0}};
                stageB[i] <= {BITS_PER_STAGE{1'b0}};
                stageSum[i] <= {BITS_PER_STAGE{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
            end
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift input enable pipeline
            en_pipe <= {en_pipe[STAGES-2:0], i_en};

            // Stage 0 inputs and carry-in
            if (i_en) begin
                stageA[0] <= adda[7:0];
                stageB[0] <= addb[7:0];
                carry[0] <= 1'b0; // carry in is zero for first stage new input
            end
            // Perform addition for stage 0
            {carry[1], stageSum[0]} <= stageA[0] + stageB[0] + carry[0];

            // Subsequent stages
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    stageA[i] <= adda[i*BITS_PER_STAGE +: BITS_PER_STAGE];
                    stageB[i] <= addb[i*BITS_PER_STAGE +: BITS_PER_STAGE];
                    carry[i] <= carry[i]; // preserve previous carry until updated below
                end
                // Add with carry-in from previous stage registered carry-out
                {carry[i+1], stageSum[i]} <= stageA[i] + stageB[i] + carry[i];
            end

            // When last pipeline stage valid, combine sum and carry out
            if (en_pipe[STAGES-1]) begin
                // Concatenate from MSB stage down to LSB stage
                // stageSum[STAGES-1] is most significant 8 bits sum
                // carry[STAGES] is overall carry out (65th bit)
                result <= {carry[STAGES], 
                           stageSum[STAGES-1], stageSum[STAGES-2], stageSum[STAGES-3], stageSum[STAGES-4],
                           stageSum[STAGES-5], stageSum[STAGES-6], stageSum[STAGES-7], stageSum[0]};
            end

            // Output enable after full pipeline delay
            o_en <= en_pipe[STAGES-1];
        end
    end

endmodule