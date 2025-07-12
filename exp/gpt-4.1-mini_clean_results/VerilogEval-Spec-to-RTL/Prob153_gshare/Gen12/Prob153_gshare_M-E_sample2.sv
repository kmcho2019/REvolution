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

    // PHT: 128 x 2-bit saturating counters, synchronous read/write
    reg [1:0] pht [0:127];

    // Predictor pipeline registers:
    // Stage 1: latch inputs for prediction
    reg predict_valid_pipe;
    reg [6:0] predict_pc_pipe;
    reg [6:0] predict_ghr_pipe;

    // Stage 2: indexed read results, after address generation and PHT read
    reg [6:0] predict_index_pipe2;
    reg [1:0] predict_counter_pipe2;
    reg predict_valid_pipe2;
    reg [6:0] predict_ghr_pipe2;

    // Global History Register
    reg [6:0] ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

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

    // Prediction index calculation stage 1
    wire [6:0] predict_index_stage1 = predict_pc_pipe ^ predict_ghr_pipe;

    // Synchronous PHT read on clk: read pht[predict_index_stage1] -> stored in predict_counter_pipe2

    // -----------------------
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;

            // Clear predictor pipeline registers
            predict_valid_pipe <= 1'b0;
            predict_pc_pipe <= 7'b0;
            predict_ghr_pipe <= 7'b0;

            predict_valid_pipe2 <= 1'b0;
            predict_index_pipe2 <= 7'b0;
            predict_counter_pipe2 <= 2'b01; // weak not taken default
            predict_ghr_pipe2 <= 7'b0;

            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // -------------------
            // Training logic - update PHT synchronously
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // -------------------
            // Predictor pipeline stage 1 - latch prediction request and GHR
            if (predict_valid) begin
                predict_valid_pipe <= 1'b1;
                predict_pc_pipe <= predict_pc;
                predict_ghr_pipe <= ghr;
            end else begin
                predict_valid_pipe <= 1'b0;
            end

            // -------------------
            // Predictor pipeline stage 2 - synchronous PHT read
            // Read PHT at address predict_index_stage1 from previous stage
            predict_valid_pipe2 <= predict_valid_pipe;
            predict_index_pipe2 <= predict_index_stage1;
            predict_ghr_pipe2 <= predict_ghr_pipe;
            // Synchronous read from PHT
            predict_counter_pipe2 <= pht[predict_index_stage1];

            // -------------------
            // Output prediction results from pipeline stage 2
            if (predict_valid_pipe2) begin
                predict_taken <= predict_counter_pipe2[1]; // MSB is prediction bit
                predict_history <= predict_ghr_pipe2;
            end

            // -------------------
            // Update GHR with priority:
            // 1. If training with mispredict: recover GHR to train_history
            // 2. Else if training valid: shift in train_taken
            // 3. Else if prediction valid in pipeline stage 2 (prediction just completed): shift in predicted bit
            // 4. Else hold GHR

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_pipe2) begin
                ghr <= {ghr[5:0], predict_counter_pipe2[1]};
            end else begin
                ghr <= ghr;
            end
        end
    end

endmodule