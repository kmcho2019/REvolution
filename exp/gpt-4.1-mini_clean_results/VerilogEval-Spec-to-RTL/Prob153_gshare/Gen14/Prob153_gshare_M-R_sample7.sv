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

    // Register to hold the history used at prediction time
    reg [6:0] pred_history_reg;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read current PHT entries asynchronously (combinational)
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry   = pht[train_index];

    // Prediction outputs:
    // - taken if MSB of saturating counter is 1 and predict_valid
    assign predict_taken = predict_valid ? pht_predict_entry[1] : 1'b0;
    assign predict_history = pred_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state != 2'b11) ? state + 2'b01 : state;
            end else begin
                saturate_update = (state != 2'b00) ? state - 2'b01 : state;
            end
        end
    endfunction

    integer i;

    // Capture predict_history_reg on predict_valid to represent the history at prediction time
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_history_reg <= 7'b0;
        end else begin
            if (predict_valid) begin
                pred_history_reg <= ghr;
            end
            // else hold previous value to keep output stable when no prediction
        end
    end

    // Main sequential logic for PHT update and GHR update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Priority 1: Training with misprediction: recover GHR and update PHT
            if (train_valid && train_mispredicted) begin
                // Update PHT entry according to actual outcome
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
                // Recover GHR to committed history after pipeline flush
                ghr <= train_history;
            end
            // Priority 2: Training without misprediction: update PHT only
            else if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
                // GHR not updated here; keep speculative history
                // Prediction update can still update GHR below if predict_valid
                if (!predict_valid) begin
                    // No prediction this cycle, keep GHR unchanged
                    ghr <= ghr;
                end else begin
                    // Prediction will update GHR below
                    ghr <= {ghr[5:0], pht_predict_entry[1]};
                end
            end
            // Priority 3: Prediction only (no training)
            else if (predict_valid) begin
                // Update GHR with predicted bit (speculative history extension)
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