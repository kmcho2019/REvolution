module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output reg     predict_taken,
    output reg [6:0] predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // PHT: 128 x 2-bit saturating counters, synchronous read/write RAM
    reg [1:0] pht [0:127];

    integer i;

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = counter + 1;
            end else begin
                if (counter == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = counter - 1;
            end
        end
    endfunction

    // ---------------------------------------------------
    // Prediction pipeline registers (3-stage pipeline):
    //
    // Stage 1: latch prediction inputs and current GHR
    reg          predict_valid_s1;
    reg  [6:0]   predict_pc_s1;
    reg  [6:0]   predict_ghr_s1;

    // Stage 2: latch index for PHT read (pc ^ ghr)
    reg          predict_valid_s2;
    reg  [6:0]   predict_index_s2;
    reg  [6:0]   predict_ghr_s2;

    // Stage 3: latch PHT output (counter)
    reg          predict_valid_s3;
    reg  [1:0]   predict_counter_s3;
    reg  [6:0]   predict_ghr_s3;

    // ---------------------------------------------------
    // Compute training index combinationally
    wire [6:0] train_index = train_pc ^ train_history;

    // ---------------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end

            // Reset GHR
            ghr <= 7'b0;

            // Clear prediction pipeline registers
            predict_valid_s1 <= 1'b0;
            predict_pc_s1    <= 7'b0;
            predict_ghr_s1   <= 7'b0;

            predict_valid_s2 <= 1'b0;
            predict_index_s2 <= 7'b0;
            predict_ghr_s2   <= 7'b0;

            predict_valid_s3 <= 1'b0;
            predict_counter_s3 <= 2'b01;
            predict_ghr_s3     <= 7'b0;

            // Clear outputs
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // ----------- Training: Update PHT synchronously -----------
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // ----------- Prediction pipeline stage 1 -----------
            // Latch prediction inputs and GHR when valid
            if (predict_valid) begin
                predict_valid_s1 <= 1'b1;
                predict_pc_s1    <= predict_pc;
                predict_ghr_s1   <= ghr;
            end else begin
                predict_valid_s1 <= 1'b0;
            end

            // ----------- Prediction pipeline stage 2 -----------
            // Compute index = pc ^ ghr latched in stage 1
            predict_valid_s2 <= predict_valid_s1;
            predict_index_s2 <= predict_pc_s1 ^ predict_ghr_s1;
            predict_ghr_s2   <= predict_ghr_s1;

            // ----------- Prediction pipeline stage 3 -----------
            predict_valid_s3 <= predict_valid_s2;
            predict_ghr_s3   <= predict_ghr_s2;

            // Synchronous read from PHT at stage 3
            // The PHT read corresponds to the address latched at stage 2 on last cycle
            // This models synchronous RAM read: data available one cycle after address latch
            predict_counter_s3 <= pht[predict_index_s2];

            // ----------- Produce outputs based on stage 3 -----------

            if (predict_valid_s3) begin
                // MSB of counter is prediction bit
                predict_taken   <= predict_counter_s3[1];
                predict_history <= predict_ghr_s3; // history used for prediction (GHR at prediction request)
            end else begin
                // No valid prediction, hold outputs or clear (chosen to hold)
                // This avoids glitches when no prediction valid
                // Could also clear outputs if preferred:
                // predict_taken <= 1'b0;
                // predict_history <= 7'b0;
            end

            // ----------- Update GHR with priority on training -----------

            if (train_valid && train_mispredicted) begin
                // Recover GHR to history after mispredicted branch
                ghr <= train_history;
            end else if (train_valid) begin
                // Update GHR with actual branch outcome from training
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_s3) begin
                // Update GHR with predicted bit at prediction completion stage
                ghr <= {ghr[5:0], predict_counter_s3[1]};
            end else begin
                // Hold GHR when no updates
                ghr <= ghr;
            end
        end
    end

endmodule