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

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Registered outputs for prediction results
    reg        predict_taken_reg;
    reg  [6:0] predict_history_reg;

    // Compute indices for prediction and training
    wire [6:0] pred_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Current saturating counter for prediction index (combinational read)
    wire [1:0] pred_counter = pht[pred_index];
    wire       pred_taken = pred_counter[1]; // MSB = taken/not taken

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If mispredicted training, restore GHR to train_history
            // 2) Else if training, shift in train_taken
            // 3) Else if prediction valid, shift in predicted taken
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pred_taken};
            end

            // Latch prediction outputs only when predict_valid asserted
            if (predict_valid) begin
                predict_taken_reg <= pred_taken;
                predict_history_reg <= ghr;
            end
            // Otherwise hold previous outputs
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule