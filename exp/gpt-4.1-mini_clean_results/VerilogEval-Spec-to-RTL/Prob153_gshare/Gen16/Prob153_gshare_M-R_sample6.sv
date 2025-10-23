module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

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

    // Pipeline registers holding prediction stage info to next cycle
    reg        predict_valid_d;
    reg [6:0]  predict_pc_d;
    reg [6:0]  predict_history_d;
    reg [1:0]  pht_predict_entry_d;

    // Function: saturating counter next state update
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

    // Combinational: compute current predict index and read PHT entry
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Combinational: compute training index and read PHT entry for training
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;

            predict_valid_d <= 1'b0;
            predict_pc_d <= 7'b0;
            predict_history_d <= 7'b0;
            pht_predict_entry_d <= 2'b00;

            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Pipeline registers: latch prediction info from current inputs & PHT reads
            predict_valid_d <= predict_valid;
            predict_pc_d <= predict_pc;
            predict_history_d <= ghr;
            pht_predict_entry_d <= pht_predict_entry;

            // Update predict outputs from previous cycle's pipeline registers
            predict_taken <= predict_valid_d && pht_predict_entry_d[1];
            predict_history <= predict_history_d;

            // PHT update on training: only update if train_valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end

            // Update GHR with priority:
            // 1) Training misprediction recovery
            // 2) Else if prediction valid previous cycle, update GHR speculatively with predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid_d) begin
                ghr <= {ghr[5:0], pht_predict_entry_d[1]};
            end
            // else keep ghr unchanged
        end
    end

endmodule