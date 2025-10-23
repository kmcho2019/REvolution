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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Registers:
    // speculative GHR: updated with predicted outcomes, used for indexing prediction
    // committed GHR: architectural history, updated on training outcomes
    reg [6:0] speculative_GHR;
    reg [6:0] committed_GHR;

    integer i;

    // Saturating counter update function (2-bit saturating counter)
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default to weakly not taken
            endcase
        end
    endfunction

    // Compute PHT indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ speculative_GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Current prediction counter read combinationally
    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1];

    // Helper function to shift a 7-bit GHR left and insert new bit at LSB
    function [6:0] ghr_shift_in;
        input [6:0] ghr_in;
        input       new_bit;
        begin
            ghr_shift_in = {ghr_in[5:0], new_bit};
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            speculative_GHR <= 7'b0;
            committed_GHR   <= 7'b0;
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update committed GHR on training events:
            // train_history represents GHR *before* this branch; shift in actual outcome
            if (train_valid) begin
                // For misprediction recovery: committed GHR set to updated train_history + train_taken
                // For normal training: similarly update committed GHR by shifting in actual outcome
                committed_GHR <= ghr_shift_in(train_history, train_taken);
            end

            // Handle misprediction recovery: reset speculative GHR to committed GHR (which is updated above)
            // When both train_valid and train_mispredicted, speculation must rollback.
            if (train_valid && train_mispredicted) begin
                speculative_GHR <= ghr_shift_in(train_history, train_taken);
                // Note: committed_GHR already updated above, so no duplicate update needed here
            end else begin
                // Update speculative GHR on prediction if valid and no training misprediction this cycle
                if (predict_valid) begin
                    speculative_GHR <= ghr_shift_in(speculative_GHR, prediction_bit);
                end
                // Else hold speculative_GHR
            end

            // Register prediction outputs only when predict_valid is asserted,
            // capturing prediction based on current PHT and speculative GHR before update
            if (predict_valid) begin
                predict_taken   <= prediction_bit;
                predict_history <= speculative_GHR;
            end
            // Otherwise outputs remain stable
        end
    end

endmodule