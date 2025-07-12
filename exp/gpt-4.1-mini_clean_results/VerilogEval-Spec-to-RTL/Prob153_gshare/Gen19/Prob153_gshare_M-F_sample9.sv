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

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Registered outputs of prediction
    reg        pred_taken_reg;
    reg  [6:0] pred_history_reg;

    // Register to hold PHT entry at prediction cycle (to freeze PHT state before training update)
    reg [1:0]  pht_pred_entry_reg;

    // Prediction and training indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Combinational read of PHT for prediction index (before any update)
    wire [1:0] pht_pred_entry_comb = pht[predict_index];

    // Prediction bit combinational: MSB of 2-bit saturating counter
    wire pred_taken_comb = pht_pred_entry_comb[1];

    // Saturating counter update function
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

    // At clock edge: latch PHT entry and GHR snapshot when prediction valid
    // This freezes PHT state for prediction output before training update changes PHT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht_pred_entry_reg <= 2'b01;      // weakly not taken default
            pred_taken_reg <= 1'b0;
            pred_history_reg <= 7'b0;
        end else begin
            if (predict_valid) begin
                pht_pred_entry_reg <= pht_pred_entry_comb;  // freeze PHT before training update
                pred_taken_reg <= pht_pred_entry_comb[1];
                pred_history_reg <= ghr;                     // snapshot GHR before update
            end
        end
    end

    // Output assignments
    assign predict_taken = pred_taken_reg;
    assign predict_history = pred_history_reg;

    // Sequential update of PHT and GHR on clock edge or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT from training, if valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training valid and mispredicted, restore GHR to train_history
            // 2) Else if prediction valid and no training mispredicted, update GHR with predicted taken bit (from frozen PHT entry)
            // 3) Else hold current GHR
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_pred_entry_reg[1]};
            end
            // else retain ghr (no else needed)
        end
    end

endmodule