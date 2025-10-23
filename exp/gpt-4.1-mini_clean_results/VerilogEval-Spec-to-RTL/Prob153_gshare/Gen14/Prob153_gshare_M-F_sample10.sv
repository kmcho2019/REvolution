module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    // 00 = strongly not taken, 01 = weakly not taken,
    // 10 = weakly taken, 11 = strongly taken
    reg [1:0] pht [0:127];

    // Committed global history register (reflects actual outcomes after training)
    reg [6:0] ghr_committed;

    // Speculative global history register (updated on predictions; corrected on mispred)
    reg [6:0] ghr_predict;

    // Compute prediction index (combinational)
    wire [6:0] pred_index = predict_pc ^ ghr_predict;
    wire [1:0] pred_counter = pht[pred_index];

    // Compute training index (combinational, outside always block)
    wire [6:0] train_idx = train_pc ^ train_history;

    // Predict taken if MSB of saturating counter is 1
    assign predict_taken = predict_valid ? pred_counter[1] : 1'b0;

    // Output the speculative history used for prediction (since prediction depends on ghr_predict)
    assign predict_history = predict_valid ? ghr_predict : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                // Saturate at 3
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                // Saturate at 0
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr_committed <= 7'b0;
            ghr_predict <= 7'b0;
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                // Update saturating counter
                pht[train_idx] <= saturate_update(pht[train_idx], train_taken);

                // Update committed GHR: shift left and insert actual outcome bit
                ghr_committed <= {ghr_committed[5:0], train_taken};

                // If mispredicted, recover speculative history to committed history after this branch
                if (train_mispredicted) begin
                    // train_history is the history after the mispredicting branch completed
                    ghr_predict <= train_history;
                end else begin
                    // No misprediction recovery here, keep ghr_predict unchanged for now
                    ghr_predict <= ghr_predict;
                end
            end else begin
                // No training this cycle, keep committed GHR unchanged
                ghr_committed <= ghr_committed;
                ghr_predict <= ghr_predict;
            end

            // Update speculative history for predictions
            // If prediction valid and no misprediction recovery this cycle, update ghr_predict by shifting in predicted bit
            // Training with misprediction takes precedence over prediction update
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr_predict <= {ghr_predict[5:0], pred_counter[1]};
            end
            // else if misprediction recovery happened above, ghr_predict was restored to train_history
            // else no prediction, ghr_predict unchanged
        end
    end

endmodule