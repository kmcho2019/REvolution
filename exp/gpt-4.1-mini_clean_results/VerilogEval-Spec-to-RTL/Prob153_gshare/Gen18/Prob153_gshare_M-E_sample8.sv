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

    // 128-entry Pattern History Table (PHT) of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Speculative global history register (updated on prediction)
    reg [6:0] ghr_spec;

    // Committed global history register (updated on training)
    reg [6:0] ghr_comm;

    // Internal registers to hold outputs stable
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Compute indices by XOR of PC and history
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries asynchronously for prediction and training
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction: taken if MSB of saturating counter is 1
    wire predicted_taken = pht_predict_entry[1] && predict_valid;

    // Saturating counter update logic
    function [1:0] saturate_update;
        input [1:0] curr;
        input       taken;
        begin
            if (taken) begin
                if (curr != 2'b11)
                    saturate_update = curr + 2'b01;
                else
                    saturate_update = curr;
            end else begin
                if (curr != 2'b00)
                    saturate_update = curr - 2'b01;
                else
                    saturate_update = curr;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            // Clear histories
            ghr_spec <= 7'b0;
            ghr_comm <= 7'b0;

            // Clear output registers
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Hold current outputs stable by default (if no new prediction)
            predict_taken_reg <= predict_taken_reg;
            predict_history_reg <= predict_history_reg;

            // 1) Update PHT on training, if valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On misprediction training:
                    // Recover speculative and committed histories to train_history (state after mispredicted branch)
                    ghr_spec <= train_history;
                    ghr_comm <= train_history;
                end else begin
                    // On correct training:
                    // Commit the actual outcome by updating committed history shifting in train_taken
                    ghr_comm <= {ghr_comm[5:0], train_taken};
                    // Also update speculative history if it lags committed (ensuring ghr_spec is at least ghr_comm)
                    // Only update ghr_spec if ghr_spec is behind committed
                    // But since speculation may be ahead, we do not revert speculative history here.
                end
            end else begin
                // No training update, but may have prediction update to speculative history
                if (predict_valid) begin
                    // Update speculative history by shifting in predicted_taken bit
                    ghr_spec <= {ghr_spec[5:0], predicted_taken};
                end
                // Else no update to histories
            end

            // 2) Output the prediction and history used for prediction, stable and valid only when predict_valid is asserted
            if (predict_valid) begin
                predict_taken_reg <= predicted_taken;
                predict_history_reg <= ghr_spec; // ghr_spec before update (since update is at posedge)
            end
            // Else outputs hold previous values (stable outputs)
        end
    end

    // Output assignments
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule