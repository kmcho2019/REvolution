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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers:
    // committed_ghr: reflects the last correct global history state (retired branches)
    // speculative_ghr: reflects speculative history with predictions applied
    reg [6:0] committed_ghr;
    reg [6:0] speculative_ghr;

    // Compute indices for PHT accesses
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry   = pht[train_index];

    // Prediction output is valid only when predict_valid asserted,
    // predicted taken if MSB of counter is 1
    assign predict_taken  = predict_valid && pht_predict_entry[1];
    assign predict_history = speculative_ghr; // speculative_ghr is history used for prediction

    // Saturating counter update logic for 2-bit counters
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = state + 2'b01;
            end else begin
                if (state == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
        end else begin
            // Update PHT on training
            if (train_valid)
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

            // If misprediction: recover both history registers to train_history,
            // discarding speculative state after mispredicted branch
            if (train_valid && train_mispredicted) begin
                committed_ghr   <= train_history;
                speculative_ghr <= train_history;
            end else begin
                // Otherwise, update committed history with the actual branch outcome:
                // shift committed_ghr in with train_taken only if training valid and no mispredict
                if (train_valid) begin
                    // Shift in actual branch outcome into committed_ghr
                    // committed_ghr reflects last known correct history
                    committed_ghr <= {train_history[5:0], train_taken};
                    // Speculative history remains unchanged here
                end

                // Update speculative_ghr on prediction with predicted taken bit
                // Only if predict_valid and no misprediction recovery (which has priority)
                if (predict_valid) begin
                    // Shift in predicted taken bit (MSB of pht_predict_entry)
                    speculative_ghr <= {speculative_ghr[5:0], pht_predict_entry[1]};
                end
                // else speculative_ghr unchanged
            end
        end
    end

endmodule