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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Registers
    reg [6:0] committed_ghr;     // Committed (architectural) GHR
    reg [6:0] speculative_ghr;   // Speculative GHR used for prediction

    // Prediction signals computed combinationally before clock edge
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_taken_wire = predict_counter[1]; // MSB of counter

    // Saturating counter update function
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

    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Outputs at clock edge: latch prediction info
    // Only update outputs if predict_valid is asserted, otherwise hold
    // outputs stable.
    // Use temporary registers for outputs at clock edge.
    reg next_predict_taken;
    reg [6:0] next_predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;

            committed_ghr   <= 7'b0;
            speculative_ghr <= 7'b0;

            predict_taken   <= 1'b0;
            predict_history <= 7'b0;

            next_predict_taken   <= 1'b0;
            next_predict_history <= 7'b0;
        end else begin
            // 1. Update outputs only if predict_valid, else hold previous outputs
            if (predict_valid) begin
                next_predict_taken   <= predict_taken_wire;
                next_predict_history <= speculative_ghr;
            end
            // If predict_valid == 0, next_predict_* keep previous values

            predict_taken   <= next_predict_taken;
            predict_history <= next_predict_history;

            // 2. Update PHT if training is valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 3. Handle global history updates with priority:
            //    (a) Training misprediction recovery
            //    (b) Training update (commit)
            //    (c) Prediction update (speculative)
            if (train_valid && train_mispredicted) begin
                // Recover to committed history snapshot provided by train_history
                committed_ghr   <= train_history;
                speculative_ghr <= train_history;
            end else if (train_valid) begin
                // Commit actual outcome to committed GHR
                committed_ghr <= {committed_ghr[5:0], train_taken};
                // Sync speculative GHR to committed GHR, discarding speculative updates
                speculative_ghr <= {committed_ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // No training or misprediction recovery: speculatively update GHR with predicted bit
                speculative_ghr <= {speculative_ghr[5:0], predict_taken_wire};
            end
            // else hold speculative_ghr unchanged if no valid operations
        end
    end

endmodule