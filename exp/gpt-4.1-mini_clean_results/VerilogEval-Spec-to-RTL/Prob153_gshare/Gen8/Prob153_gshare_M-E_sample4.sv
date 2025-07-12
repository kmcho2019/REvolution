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

    // Saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Architectural (committed) global history register - updated on resolved branch training (correct branches)
    reg [6:0] ghr_committed;

    // Speculative global history register - updated on prediction or restored on misprediction
    reg [6:0] ghr_spec;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Predict outputs combinationally
    assign predict_taken = pht_predict_entry[1]; // MSB indicates taken
    assign predict_history = ghr_spec;

    // Saturating counter update logic for training
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            case(state)
                SN: saturate_update = taken ? WN : SN;
                WN: saturate_update = taken ? WT : SN;
                WT: saturate_update = taken ? ST : WN;
                ST: saturate_update = taken ? ST : WT;
                default: saturate_update = WN; // safe fallback
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
        end else begin
            // Update PHT on training request
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Global history updates:
            // Priority:
            // 1) If training valid and mispredicted, recover speculative history to train_history
            // 2) Else if training valid and NOT mispredicted, update committed history with trained outcome,
            //    and set speculative history equal to committed history (in-order progress)
            // 3) Else if prediction valid, update speculative history by shifting in predicted bit
            // 4) Else hold current histories

            if (train_valid && train_mispredicted) begin
                // Recover speculative history to state after resolved mispredicted branch
                ghr_spec <= train_history;
                // Also update committed history to train_history because architecture must reflect resolved state
                ghr_committed <= train_history;
            end else if (train_valid && !train_mispredicted) begin
                // Update committed history by shifting in actual outcome
                ghr_committed <= {train_history[5:0], train_taken};
                // Also update speculative history to match committed for architectural progress
                ghr_spec <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                // Speculatively update speculative history by shifting in prediction
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // else keep histories unchanged
        end
    end

endmodule