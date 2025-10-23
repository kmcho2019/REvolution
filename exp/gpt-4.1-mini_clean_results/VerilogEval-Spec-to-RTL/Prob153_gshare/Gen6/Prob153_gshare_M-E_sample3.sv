module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 128-entry Pattern History Table (2-bit saturating counters)
    reg [1:0] PHT [0:127];

    // Two global history registers:
    // committed_ghr: architecturally correct, updated only by training (including recovery)
    // speculative_ghr: tracks predictions for speculative chaining of predictions
    reg [6:0] committed_ghr;
    reg [6:0] speculative_ghr;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ committed_ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read counter for prediction combinationally (from committed PHT and committed_ghr)
    wire [1:0] predict_counter = PHT[predict_index];

    // Next state of saturating counter helper function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Asynchronous reset initializes PHT and both GHRs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            committed_ghr <= 7'b0;
            speculative_ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // Weakly not taken
            end
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Handle GHR updates:
            // Priority: If mispredicted training -> recover committed GHR to train_history and sync speculative GHR
            // Else if prediction valid -> speculative_ghr shifts in predicted bit (speculative update)
            // Committed GHR updated only on training (non-mispredicted) to commit confirmed branch outcomes

            if (train_valid && train_mispredicted) begin
                // Recover committed and speculative GHR to training history on mispredict
                committed_ghr <= train_history;
                speculative_ghr <= train_history;
            end else begin
                // If training valid and not mispredicted, update committed GHR with actual outcome
                if (train_valid && !train_mispredicted) begin
                    committed_ghr <= {committed_ghr[5:0], train_taken};
                    // On training commit, speculative_ghr should be aligned with committed if no misprediction
                    speculative_ghr <= {speculative_ghr[5:0], train_taken};
                end else begin
                    // No training commit or misprediction, speculative_ghr updated on prediction
                    if (predict_valid) begin
                        speculative_ghr <= {speculative_ghr[5:0], predict_counter[1]};
                    end
                    // Else hold speculative_ghr
                end
            end

            // Register outputs only on prediction valid to keep outputs stable otherwise
            if (predict_valid) begin
                predict_taken <= predict_counter[1];
                predict_history <= committed_ghr;
            end
        end
    end

endmodule