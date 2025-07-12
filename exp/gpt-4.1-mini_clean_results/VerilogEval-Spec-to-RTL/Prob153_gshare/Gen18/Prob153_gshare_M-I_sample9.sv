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

    // Prediction index combinational: XOR of predict_pc and current GHR
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Training index combinational: XOR of train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Combinational read of PHT for prediction
    wire [1:0] pht_pred_entry = pht[predict_index];

    // Combinational prediction bit: MSB of the 2-bit saturating counter
    wire pred_taken_comb = pht_pred_entry[1];

    // Registered prediction outputs (registered on clk)
    reg pred_taken_reg;
    reg [6:0] pred_history_reg;

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

    // Register prediction outputs when predict_valid is asserted:
    // - Taken prediction from current PHT entry
    // - History is current GHR before update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_taken_reg <= 1'b0;
            pred_history_reg <= 7'b0;
        end else begin
            if (predict_valid) begin
                pred_taken_reg <= pred_taken_comb;
                pred_history_reg <= ghr;
            end
        end
    end

    // Output assignment
    assign predict_taken = pred_taken_reg;
    assign predict_history = pred_history_reg;

    // Sequential update of PHT and GHR on clock edge or asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT entry if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training valid and mispredicted: recover GHR from train_history
            // 2) Else if prediction valid and no concurrent mispredicted training: shift in predicted bit
            // 3) Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                // Update GHR by shifting in predicted taken bit (from PHT entry at prediction index before training update)
                ghr <= {ghr[5:0], pred_taken_comb};
            end
            // else no change to GHR
        end
    end

endmodule