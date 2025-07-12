module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters
    localparam STAGE_BITS = 8;
    localparam STAGES = 8; // 64 / 8

    // Stage registers
    reg [STAGE_BITS-1:0] stage_adda [0:STAGES-1];
    reg [STAGE_BITS-1:0] stage_addb [0:STAGES-1];
    reg                  stage_cin  [0:STAGES-1];

    reg [STAGE_BITS-1:0] stage_sum  [0:STAGES-1];
    reg                  stage_cout [0:STAGES-1];

    // Pipeline enable shift register to track valid data
    reg [STAGES:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and enables
            for (i = 0; i < STAGES; i = i + 1) begin
                stage_adda[i]  <= 0;
                stage_addb[i]  <= 0;
                stage_cin[i]   <= 0;
                stage_sum[i]   <= 0;
                stage_cout[i]  <= 0;
            end
            en_pipe <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[STAGES-1:0], i_en};

            // Stage 0: latch inputs and cin=0 if i_en asserted
            if (i_en) begin
                stage_adda[0] <= adda[7:0];
                stage_addb[0] <= addb[7:0];
                stage_cin[0]  <= 1'b0;
            end else begin
                // Hold previous if no new valid input
                stage_adda[0] <= stage_adda[0];
                stage_addb[0] <= stage_addb[0];
                stage_cin[0]  <= stage_cin[0];
            end

            // Compute sum and cout for stage 0
            {stage_cout[0], stage_sum[0]} <= stage_adda[0] + stage_addb[0] + stage_cin[0];

            // Stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    stage_adda[i] <= adda[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                    stage_addb[i] <= addb[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                    stage_cin[i]  <= stage_cout[i-1];
                end else begin
                    // Hold previous values if no valid data
                    stage_adda[i] <= stage_adda[i];
                    stage_addb[i] <= stage_addb[i];
                    stage_cin[i]  <= stage_cin[i];
                end

                // Compute sum and cout for each stage
                {stage_cout[i], stage_sum[i]} <= stage_adda[i] + stage_addb[i] + stage_cin[i];
            end

            // Output enable delayed by pipeline depth
            o_en <= en_pipe[STAGES];

            // Assemble final result when valid
            if (en_pipe[STAGES]) begin
                // Concatenate sums from highest to lowest stage, plus final carry
                result <= {
                    stage_cout[STAGES-1],
                    stage_sum[STAGES-1],
                    stage_sum[STAGES-2],
                    stage_sum[STAGES-3],
                    stage_sum[STAGES-4],
                    stage_sum[STAGES-5],
                    stage_sum[STAGES-6],
                    stage_sum[STAGES-7],
                    stage_sum[0]
                };
            end else begin
                result <= 0;
            end
        end
    end

endmodule