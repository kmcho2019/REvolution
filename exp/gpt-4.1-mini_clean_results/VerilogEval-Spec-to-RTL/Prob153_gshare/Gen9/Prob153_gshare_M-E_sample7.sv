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
    // States:
    // 00 Strongly Not Taken
    // 01 Weakly Not Taken
    // 10 Weakly Taken
    // 11 Strongly Taken
    reg [1:0] pht [0:127];

    // Committed GHR: reflects resolved global history (train updates and misprediction recovery)
    reg [6:0] ghr_committed;
    // Speculative GHR: reflects predicted history including speculative updates
    reg [6:0] ghr_speculative;

    // Function to saturating increment/decrement the 2-bit counter
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = state + 1'b1;
            end else begin
                if (state == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = state - 1'b1;
            end
        end
    endfunction

    // Predict index: XOR of speculative GHR and predict_pc
    wire [6:0] predict_index = predict_pc ^ ghr_speculative;
    // Training index: XOR of train_history and train_pc
    wire [6:0] train_index = train_pc ^ train_history;

    // Read the PHT entry for prediction combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs:
    // predicted taken = MSB of the saturating counter
    assign predict_taken = pht_predict_entry[1];
    // predict_history output is the speculative GHR before inserting current prediction bit
    assign predict_history = ghr_speculative;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_committed <= 7'b0;
            ghr_speculative <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize to weakly not taken
            end
        end else begin
            // 1) Update PHT if training is valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // 2) Update committed GHR with train_valid info:
            //    - If mispredicted, recover committed GHR to train_history
            //    - Else, shift in train_taken bit
            if (train_valid) begin
                if (train_mispredicted) begin
                    ghr_committed <= train_history; // recovery
                end else begin
                    ghr_committed <= {train_history[5:0], train_taken};
                end
            end

            // 3) Update speculative GHR:
            //    - If training and mispredicted in this cycle, speculative GHR is recovered from train_history (overrides prediction)
            //    - Else if prediction valid, append predicted taken bit to speculative GHR
            //    - Else speculative GHR remains unchanged

            if (train_valid && train_mispredicted) begin
                ghr_speculative <= train_history; // recovery overrides speculation
            end else if (predict_valid) begin
                // Append predicted taken bit from PHT before training update
                ghr_speculative <= {ghr_speculative[5:0], pht_predict_entry[1]};
            end
            // else no change to speculative GHR
        end
    end

endmodule