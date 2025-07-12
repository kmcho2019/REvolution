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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (7 bits) - speculative global history
    reg [6:0] ghr;

    // Register holding the history used in current prediction
    reg [6:0] predict_history_reg;

    // Index calculation wires
    wire [6:0] predict_index = predict_pc ^ predict_history_reg;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT entries read asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output taken if MSB of saturating counter is 1 and predict_valid is asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    // predict_history output reflects the registered history used for prediction
    assign predict_history = predict_history_reg;

    // Saturating counter update function (2-bit saturating counter)
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch the history used in prediction at prediction request cycle
            // Only update predict_history_reg when predict_valid is high
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update pattern history table entry for training if train_valid is asserted
            if (train_valid)
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

            // Update GHR with priority:
            // 1) If training valid and mispredicted, recover GHR to train_history
            // 2) Else if no training misprediction, and prediction valid, update GHR speculatively by shifting in predicted bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                // Use current ghr (before update), get predicted bit from PHT entry indexed by predict_pc ^ ghr
                // Note: here ghr is current speculative history, not predict_history_reg,
                // since GHR update appends prediction to current speculative history
                wire [6:0] ghr_index = predict_pc ^ ghr;
                wire [1:0] pht_entry_for_update = pht[ghr_index];
                ghr <= {ghr[5:0], pht_entry_for_update[1]};
            end
            // else no change to ghr
        end
    end

endmodule