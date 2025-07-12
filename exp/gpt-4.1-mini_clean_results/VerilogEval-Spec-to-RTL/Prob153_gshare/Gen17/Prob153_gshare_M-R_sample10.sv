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

    // Prediction stage pipeline registers for outputs
    reg        pred_taken_reg;
    reg [6:0]  pred_history_reg;

    // Prediction index (combinational): XOR of predict_pc and current GHR
    wire [6:0] predict_index = predict_pc ^ ghr;

    // PHT entry at prediction index (combinational read)
    wire [1:0] pht_pred_entry = pht[predict_index];

    // Output prediction logic combinationally
    wire pred_taken_comb = predict_valid && pht_pred_entry[1];

    // Training index (combinational): XOR of train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
    endfunction

    integer i;

    // Prediction outputs registered to align timing with GHR and PHT state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_taken_reg <= 1'b0;
            pred_history_reg <= 7'b0;
        end else begin
            if (predict_valid) begin
                pred_taken_reg <= pht_pred_entry[1];
                pred_history_reg <= ghr; // history used for prediction before update
            end
        end
    end

    // Assign outputs from pipeline registers
    assign predict_taken = pred_taken_reg;
    assign predict_history = pred_history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update PHT table on training (always if train_valid)
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) Training misprediction: recover GHR from train_history
            // 2) Else if prediction valid and no concurrent mispredicted training: shift in predicted bit from PHT at prediction index
            // 3) Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht_pred_entry[1]};
            end
        end
    end

endmodule