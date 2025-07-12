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

    // Global History Register (7 bits) - speculative history
    reg [6:0] ghr;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entries asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction outputs: taken if MSB of saturating counter is 1
    assign predict_taken = predict_valid && pht_predict_entry[1];
    assign predict_history = ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state != 2'b11)
                    saturate_update = state + 2'b01;
                else
                    saturate_update = state;
            end else begin
                if (state != 2'b00)
                    saturate_update = state - 2'b01;
                else
                    saturate_update = state;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Priority 1: Training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Recover GHR to committed history after pipeline flush
                ghr <= train_history;
                // Update PHT entry for training
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end
            // Priority 2: Training without misprediction (no GHR recovery)
            else if (train_valid) begin
                // Update PHT entry for training
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
                // Update GHR only if no misprediction and no concurrent misprediction recovery
                if (predict_valid) begin
                    // Update GHR with predicted bit for next speculative history
                    ghr <= {ghr[5:0], pht_predict_entry[1]};
                end
                // else no update to GHR
            end
            // Priority 3: Prediction only (no training)
            else if (predict_valid) begin
                // Update GHR with predicted bit for next speculative history
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
            // Priority 4: No updates
            else begin
                // Maintain GHR value
                ghr <= ghr;
            end
        end
    end

endmodule