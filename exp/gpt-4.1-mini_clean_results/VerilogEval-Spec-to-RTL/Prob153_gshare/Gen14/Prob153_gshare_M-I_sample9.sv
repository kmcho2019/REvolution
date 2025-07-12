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

    // Pipeline register to latch history at prediction time for output
    reg [6:0] predict_history_reg;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entries asynchronously (combinational read)
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output: taken if MSB of saturating counter is 1 and predict_valid
    assign predict_taken = predict_valid && pht_predict_entry[1];

    // Output latched predict_history (history used to make the prediction)
    assign predict_history = predict_history_reg;

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

            // Reset global history and predict_history output
            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Priority 1: Training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Update PHT entry for training
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
                // Recover GHR to committed history after pipeline flush
                ghr <= train_history;
                // Capture predict_history output:
                // Since misprediction recovers GHR, prediction from this cycle will be discarded,
                // so safe to hold previous predict_history_reg or update to recovered history
                // Here keep predict_history_reg unchanged for correctness.
            end
            // Priority 2: Training without misprediction
            else if (train_valid) begin
                // Update PHT entry for training
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
                // Priority 3: Prediction valid (no misprediction)
                if (predict_valid) begin
                    // Update GHR speculatively with predicted bit from PHT for next history
                    ghr <= {ghr[5:0], pht_predict_entry[1]};
                end else begin
                    // No prediction: keep GHR unchanged (speculative history stable)
                    ghr <= ghr;
                end
            end
            // Priority 3: Prediction valid only (no training)
            else if (predict_valid) begin
                // Update GHR speculatively with predicted bit from PHT
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
            // Priority 4: No training, no prediction - hold history stable
            else begin
                ghr <= ghr;
            end

            // Latch predict_history_reg on prediction request, hold otherwise
            // This register captures the history used at the time prediction is requested,
            // so outputs correspond to GHR used to index PHT in that cycle.
            if (predict_valid) begin
                predict_history_reg <= ghr;
            end else begin
                predict_history_reg <= predict_history_reg;
            end
        end
    end

endmodule