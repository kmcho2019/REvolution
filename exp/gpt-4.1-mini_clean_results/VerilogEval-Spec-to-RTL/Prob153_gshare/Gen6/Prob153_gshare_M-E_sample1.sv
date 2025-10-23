module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Registers:
    // speculative GHR: updated at prediction time with predicted direction,
    // committed GHR: updated at training time, authoritative state
    reg [6:0] speculative_GHR;
    reg [6:0] committed_GHR;

    integer i;

    // Saturating counter update function (2-bit saturating counter)
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    // Compute PHT indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ speculative_GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Current prediction counter read combinationally
    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            speculative_GHR <= 7'b0;
            committed_GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Handle misprediction recovery: commit training history and recover speculative GHR
            if (train_valid && train_mispredicted) begin
                committed_GHR <= train_history;
                speculative_GHR <= train_history; // Recover speculative history to architectural state
            end else if (train_valid) begin
                // Normal training updates committed GHR by shifting in actual outcome
                // Assuming train_history already reflects architectural history including this branch,
                // so we don't shift here. The train_history is the GHR at time of train.
                committed_GHR <= train_history;
                // speculative_GHR stays unchanged (no recovery)
            end

            // Update speculative_GHR on prediction if no misprediction recovery this cycle
            // Prediction uses PHT state before update, so update GHR now with predicted bit
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                speculative_GHR <= {speculative_GHR[5:0], prediction_bit};
            end
            // else speculative_GHR holds value (either recovery occurred or no prediction this cycle)

            // Register prediction outputs only when predict_valid is asserted,
            // capturing prediction based on current PHT and speculative GHR before update
            if (predict_valid) begin
                predict_taken <= prediction_bit;
                predict_history <= speculative_GHR;
            end
            // Otherwise outputs remain stable
        end
    end

endmodule