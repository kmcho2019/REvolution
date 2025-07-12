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

    // 2-bit saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers
    reg [6:0] ghr_commit; // committed global history (architectural)
    reg [6:0] ghr_spec;   // speculative global history (updated on prediction, restored on recovery)

    // Compute prediction index from pc xor speculative history
    wire [6:0] predict_index = predict_pc ^ ghr_spec;

    // Current PHT counter for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction is taken if MSB of saturating counter is 1
    assign predict_taken = (predict_valid) ? pht_predict_entry[1] : 1'b0;

    // Prediction history is the speculative history before update
    assign predict_history = ghr_spec;

    // Compute training index from train_pc xor train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter next state logic for training update
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            case (state)
                SN: saturate_update = taken ? WN : SN;
                WN: saturate_update = taken ? WT : SN;
                WT: saturate_update = taken ? ST : WN;
                ST: saturate_update = taken ? ST : WT;
                default: saturate_update = WN; // default safe state
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_commit <= 7'b0;
            ghr_spec <= 7'b0;
            // Initialize PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update committed history only if training valid and no misprediction
            if (train_valid && !train_mispredicted) begin
                ghr_commit <= {ghr_commit[5:0], train_taken};
            end

            // Update speculative history:
            // Priority 1: if training misprediction, restore ghr_spec to train_history (recovery)
            // Priority 2: else if prediction valid, shift in predicted taken bit into ghr_spec
            // Else hold ghr_spec
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted bit (from PHT before update) into speculative history
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // Else ghr_spec unchanged
        end
    end

endmodule