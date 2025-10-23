module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Committed GHR (reflects confirmed outcomes after training)
    reg [6:0] commit_ghr;

    // Speculative GHR (reflects predictions in fetch)
    reg [6:0] spec_ghr;

    // Register to hold history used for prediction output
    reg [6:0] predict_history_r;

    // Compute indices:
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction counter from PHT indexed by (predict_pc XOR spec_ghr)
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction output: MSB of saturating counter indicates taken/not
    assign predict_taken = predict_counter[1];

    // Output predict_history registered at predict_valid
    assign predict_history = predict_history_r;

    // Saturating counter update helper function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    saturate_update = counter + 1;
                else
                    saturate_update = 2'b11;
            end else begin
                if (counter != 2'b00)
                    saturate_update = counter - 1;
                else
                    saturate_update = 2'b00;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            commit_ghr <= 7'b0;
            spec_ghr <= 7'b0;
            predict_history_r <= 7'b0;
        end else begin
            // Update PHT during training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update committed GHR on training events with priority:
            // 1) If mispredicted: recover committed GHR to train_history
            // 2) Else if valid training: shift in train_taken
            // 3) Else no change
            if (train_valid && train_mispredicted) begin
                commit_ghr <= train_history;
            end else if (train_valid) begin
                commit_ghr <= {commit_ghr[5:0], train_taken};
            end

            // Speculative GHR update logic:
            // If misprediction training this cycle -> reset spec GHR to committed GHR (recover)
            // Else if prediction valid -> update spec GHR with predicted bit
            // Else keep spec GHR unchanged
            if (train_valid && train_mispredicted) begin
                spec_ghr <= train_history;
            end else if (predict_valid) begin
                // Append predicted bit (MSB of PHT counter for predicted PC & current spec GHR)
                spec_ghr <= {spec_ghr[5:0], predict_counter[1]};
            end

            // Register the predict history when predict_valid asserted (before speculative GHR update)
            // Use a non-blocking assignment delayed by 1 clock so that predict_history_r reflects spec_ghr before update.
            if (predict_valid) begin
                predict_history_r <= spec_ghr;
            end
        end
    end

endmodule