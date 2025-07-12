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
    // Encoding:
    // 00 - Strongly Not Taken
    // 01 - Weakly Not Taken
    // 10 - Weakly Taken
    // 11 - Strongly Taken
    reg [1:0] pht [0:127];

    // Global History Registers:
    // ghr: committed global history register (stable state reflecting processor's actual global history)
    // spec_ghr: speculative global history register updated based on predicted outcomes
    reg [6:0] ghr;
    reg [6:0] spec_ghr;

    // Registered prediction inputs to synchronize outputs
    reg        predict_valid_r;
    reg [6:0]  predict_pc_r;

    // Calculate PHT index for prediction: use committed global history XOR pc
    wire [6:0] predict_index = predict_pc_r ^ ghr;

    // Calculate PHT index for training: use train_history XOR train_pc
    wire [6:0] train_index = train_history ^ train_pc;

    // Read PHT entry for prediction combinationally
    wire [1:0] pht_pred_entry = pht[predict_index];

    // Prediction output uses MSB of saturating counter as taken bit
    assign predict_taken = predict_valid_r ? pht_pred_entry[1] : 1'b0;

    // Output the history used for the prediction: stable committed ghr
    assign predict_history = predict_valid_r ? ghr : 7'b0;

    // Function to saturate update 2-bit counter based on actual branch outcome
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1;
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
            ghr <= 7'b0;
            spec_ghr <= 7'b0;
            predict_valid_r <= 1'b0;
            predict_pc_r <= 7'b0;
        end else begin
            // Register prediction inputs
            predict_valid_r <= predict_valid;
            predict_pc_r <= predict_pc;

            // Update PHT on training valid cycle with saturating counter logic
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update speculative global history with priority:
            // 1) If training misprediction, recover histories to train_history
            // 2) Else if prediction valid, update speculative history by shifting in predicted taken bit
            // 3) Else keep current speculative history unchanged
            if (train_valid && train_mispredicted) begin
                spec_ghr <= train_history;
            end else if (predict_valid) begin
                // Update speculative history: shift left and insert predicted taken bit from pre-update PHT
                spec_ghr <= {spec_ghr[5:0], pht_pred_entry[1]};
            end else begin
                spec_ghr <= spec_ghr;
            end

            // Commit speculative history as the new committed history after all updates
            ghr <= spec_ghr;
        end
    end

endmodule