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

    // Register to hold the GHR value used at prediction request (for predict_history output)
    reg [6:0] predict_history_reg;

    // Combinational indices
    wire [6:0] predict_index = predict_pc ^ ghr;       // Use current ghr for prediction indexing
    wire [6:0] train_index   = train_pc ^ train_history;

    // Combinational PHT reads for prediction and training
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry   = pht[train_index];

    // Predict taken if MSB of PHT entry is 1 and predict_valid asserted
    assign predict_taken = predict_valid && (pht_predict_entry[1] == 1'b1);

    // Output the history register state used for prediction (registered at predict_valid)
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
            // Capture the GHR value used for prediction when predict_valid is asserted
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT entry at train_index on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end

            // Update GHR with priority:
            // 1) Recover GHR to train_history on mispredicted training
            // 2) Else if predict_valid, shift in predicted bit (from pht_predict_entry[1])
            // 3) Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                // Recover GHR to train_history (highest priority)
                ghr <= train_history;
            end else if (predict_valid) begin
                // Update GHR with predicted bit (MSB of PHT entry at predict_index)
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
            // else keep ghr as is
        end
    end

endmodule