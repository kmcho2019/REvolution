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

    // Latch of history used for prediction outputs
    reg [6:0] predict_history_reg;

    // Calculate indices for PHT access
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries asynchronously for prediction and training
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output: taken if MSB of saturating counter is 1 and predict_valid is asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];

    // Output the history register used for prediction
    assign predict_history = predict_history_reg;

    // Saturating counter update function (2-bit saturating counter)
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
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Capture the current GHR as prediction history at prediction request
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT entry on training request
            if (train_valid)
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

            // Update GHR: priority given to training recovery on misprediction
            if (train_valid && train_mispredicted) begin
                // Recover GHR to train_history after misprediction
                ghr <= train_history;
            end else if (predict_valid) begin
                // Speculative GHR update: shift in predicted taken bit (MSB of PHT entry at predict_index)
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
            // else retain current GHR
        end
    end

endmodule