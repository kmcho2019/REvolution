module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Parameters
    localparam STAGE_BITS = 16;
    localparam STAGES = 4; // 64 / 16

    // Pipeline registers for operands and carry per stage
    reg [STAGE_BITS-1:0] stage_adda [0:STAGES-1];
    reg [STAGE_BITS-1:0] stage_addb [0:STAGES-1];
    reg                  stage_cin  [0:STAGES-1]; // carry in for each stage

    // Pipeline registers for sum output per stage
    reg [STAGE_BITS-1:0] stage_sum [0:STAGES-1];
    reg                  stage_cout[0:STAGES-1]; // carry out per stage

    // Enable pipeline shift register: delays i_en by STAGES cycles
    reg [STAGES:0] en_pipe;

    integer i;

    // Stage 0 inputs latch
    // Carry in for stage 0 is 0 when new input arrives

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and enables
            for (i = 0; i < STAGES; i = i + 1) begin
                stage_adda[i]   <= 0;
                stage_addb[i]   <= 0;
                stage_cin[i]    <= 0;
                stage_sum[i]    <= 0;
                stage_cout[i]   <= 0;
            end
            en_pipe <= 0;
            result  <= 0;
            o_en    <= 0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[STAGES-1:0], i_en};

            // Stage 0: latch inputs and cin=0 if i_en
            if (i_en) begin
                stage_adda[0] <= adda[15:0];
                stage_addb[0] <= addb[15:0];
                stage_cin[0]  <= 1'b0;
            end else begin
                // Hold previous values (optional; can remove if not needed)
                stage_adda[0] <= stage_adda[0];
                stage_addb[0] <= stage_addb[0];
                stage_cin[0]  <= stage_cin[0];
            end

            // Compute sum and carry out for stage 0 combinationally
            {stage_cout[0], stage_sum[0]} <= stage_adda[0] + stage_addb[0] + stage_cin[0];

            // Propagate data through pipeline stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Latch inputs from previous stage outputs one cycle later
                if (en_pipe[i-1]) begin
                    stage_adda[i] <= adda[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                    stage_addb[i] <= addb[(i+1)*STAGE_BITS-1 -: STAGE_BITS];
                    stage_cin[i]  <= stage_cout[i-1]; // carry in is previous stage carry out
                end else begin
                    // Hold previous values if no new valid data
                    stage_adda[i] <= stage_adda[i];
                    stage_addb[i] <= stage_addb[i];
                    stage_cin[i]  <= stage_cin[i];
                end

                // Compute sum and carry out for this stage combinationally
                {stage_cout[i], stage_sum[i]} <= stage_adda[i] + stage_addb[i] + stage_cin[i];
            end

            // Output enable is delayed input enable after STAGES cycles
            o_en <= en_pipe[STAGES];

            // When output is valid, assemble result from all stage sums and final carry out
            if (en_pipe[STAGES]) begin
                result <= {
                    stage_cout[STAGES-1],
                    stage_sum[STAGES-1],
                    stage_sum[STAGES-2],
                    stage_sum[STAGES-3],
                    stage_sum[0]
                };
                // Note: concatenate in descending order of stage index to get full 65 bits:
                // {carry_out_stage3, sum_stage3[15:0], sum_stage2[15:0], sum_stage1[15:0], sum_stage0[15:0]}
            end else begin
                result <= 0;
            end
        end
    end

endmodule