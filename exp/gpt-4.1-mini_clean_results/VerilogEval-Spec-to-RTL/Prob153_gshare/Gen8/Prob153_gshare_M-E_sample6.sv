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

    // 2-bit saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    // Pattern History Table (PHT)
    reg [1:0] PHT [0:127];

    // Architectural (committed) GHR: reflects committed branch outcomes
    reg [6:0] arch_ghr;

    // Speculative GHR: updated on prediction cycles with predicted bits
    reg [6:0] spec_ghr;

    integer i;

    // Combinational index for prediction: pc XOR speculative GHR
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1];

    // Combinational index for training update: train_pc XOR train_history (architectural history)
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;
            arch_ghr <= 7'b0;
            spec_ghr <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Training updates PHT and architectural GHR
            if (train_valid) begin
                // Update PHT entry at train_index
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update architectural and speculative GHRs based on training and prediction
            if (train_valid && train_mispredicted) begin
                // On misprediction, rollback: arch_ghr and spec_ghr both set to train_history
                arch_ghr <= train_history;
                spec_ghr <= train_history;
            end else if (train_valid) begin
                // On non-misprediction training, commit architectural history to train_history
                arch_ghr <= train_history;
                // Speculative GHR also updated to committed state (synchronized)
                spec_ghr <= train_history;
            end else if (predict_valid) begin
                // No training or no misprediction this cycle, update speculative GHR with predicted bit
                spec_ghr <= {spec_ghr[5:0], prediction_bit};
            end

            // Output prediction results: outputs reflect prediction and speculative GHR at this cycle (before update)
            // So update outputs from combinational inputs *before* updating speculative GHR on next cycle
            if (predict_valid) begin
                predict_taken <= prediction_bit;
                predict_history <= spec_ghr;
            end
            // Otherwise maintain outputs stable
        end
    end

endmodule