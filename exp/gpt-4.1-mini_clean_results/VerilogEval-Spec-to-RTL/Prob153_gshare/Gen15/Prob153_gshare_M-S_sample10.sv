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

    // Global History Register
    reg [6:0] ghr;

    // Registered prediction outputs (valid at next cycle)
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Prediction index and counter read at current cycle
    wire [6:0] pred_index = predict_pc ^ ghr;
    wire [1:0] pred_counter = pht[pred_index];
    wire       pred_taken = pred_counter[1];  // MSB indicates taken or not

    // Function for saturating counter update
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
            // --- Update PHT on training ---
            if (train_valid) begin
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);
            end

            // --- Update GHR with priority ---
            // 1) If misprediction training, restore GHR to train_history
            // 2) else if training, update GHR with train_taken
            // 3) else if prediction valid (and no mispredicted training), update with predicted taken
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pred_taken};
            end

            // --- Latch prediction outputs and history when prediction valid ---
            if (predict_valid) begin
                predict_taken_reg <= pred_taken;
                predict_history_reg <= ghr;
            end
            // else hold previous outputs stable
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule