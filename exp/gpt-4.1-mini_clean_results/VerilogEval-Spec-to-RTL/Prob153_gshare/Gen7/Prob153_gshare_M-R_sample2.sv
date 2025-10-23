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

    // Global History Registers
    reg [6:0] committed_ghr;    // Architecturally committed GHR
    reg [6:0] speculative_ghr;  // Speculative GHR updated on predictions

    // Index calculation for prediction and training
    wire [6:0] predict_index  = predict_pc ^ speculative_ghr;
    wire [6:0] train_index    = train_pc ^ train_history;

    // Combinational read of PHT counters
    wire [1:0] predict_counter = PHT[predict_index];

    // Predicted taken bit from MSB of saturating counter
    wire       predict_taken_wire = predict_counter[1];

    // For combinational output, output history used for prediction (speculative_ghr)
    wire [6:0] predict_history_wire = speculative_ghr;

    // Helper function for saturating counter update
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    // Sequential logic for PHT and GHR updates and output registering
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            committed_ghr   <= 7'b0;
            speculative_ghr <= 7'b0;
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Handle GHR updates: Training with misprediction recovery has highest priority
            if (train_valid && train_mispredicted) begin
                // Recover both GHRs to committed history after misprediction
                committed_ghr   <= train_history;
                speculative_ghr <= train_history;
            end else begin
                // If training valid and no mispredict: commit actual outcome
                if (train_valid && !train_mispredicted) begin
                    committed_ghr   <= {committed_ghr[5:0], train_taken};
                    speculative_ghr <= {speculative_ghr[5:0], train_taken};
                end else begin
                    // No training commit: update speculative_ghr on prediction if valid
                    if (predict_valid) begin
                        // Speculative update with predicted bit from current PHT state
                        speculative_ghr <= {speculative_ghr[5:0], predict_taken_wire};
                    end
                    // Otherwise hold speculative_ghr as is
                end
            end

            // Register outputs only on prediction valid to hold stable otherwise
            if (predict_valid) begin
                predict_taken   <= predict_taken_wire;
                predict_history <= predict_history_wire;
            end
        end
    end

endmodule