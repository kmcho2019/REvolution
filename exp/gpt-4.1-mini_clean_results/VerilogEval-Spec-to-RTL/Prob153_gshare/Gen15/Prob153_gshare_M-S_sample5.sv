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

    // Register holding history used for prediction output
    reg [6:0] predict_history_reg;

    // Index for prediction (pc XOR predict_history_reg)
    wire [6:0] predict_index = predict_pc ^ predict_history_reg;
    // Index for training (pc XOR train_history)
    wire [6:0] train_index = train_pc ^ train_history;
    // Index for GHR update prediction (predict_pc XOR current ghr)
    wire [6:0] ghr_predict_index = predict_pc ^ ghr;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];
    wire [1:0] pht_ghr_predict_entry = pht[ghr_predict_index];

    // Prediction taken output based on MSB of PHT entry at predict_index and predict_valid
    assign predict_taken = predict_valid && pht_predict_entry[1];
    // Output the history captured at prediction request
    assign predict_history = predict_history_reg;

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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Capture prediction history at prediction request
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT on training valid
            if (train_valid)
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

            // Update GHR with priority:
            // 1) If mispredicted training: recover GHR to train_history
            // 2) Else if predict valid and no concurrent training mispredict: shift in prediction bit
            // 3) Else no change
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht_ghr_predict_entry[1]};
            end
            // else keep ghr unchanged
        end
    end

endmodule