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
    reg [6:0] committed_ghr;     // Architecturally committed GHR
    reg [6:0] speculative_ghr;   // Speculative GHR updated on predictions

    // Prediction combinational signals
    wire [6:0] predict_index  = predict_pc ^ speculative_ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_taken_wire = predict_counter[1]; // MSB is prediction taken

    // Training combinational signals
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function for 2-bit counters
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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            committed_ghr   <= 7'b0;
            speculative_ghr <= 7'b0;
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // 1) Register outputs first to reflect pre-update PHT & speculative GHR state
            // Only update outputs if predict_valid is asserted
            if (predict_valid) begin
                predict_taken   <= predict_taken_wire;
                predict_history <= speculative_ghr;
            end
            // If predict_valid is low, outputs hold previous values

            // 2) Update PHT at clock edge if training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 3) Update GHRs (committed and speculative)
            if (train_valid && train_mispredicted) begin
                // Misprediction recovery: override GHRs with training history
                committed_ghr   <= train_history;
                speculative_ghr <= train_history;
            end else if (train_valid && !train_mispredicted) begin
                // Training with correct prediction: commit actual outcome
                committed_ghr   <= {committed_ghr[5:0], train_taken};
                speculative_ghr <= {committed_ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // No training or no misprediction: update speculative GHR with predicted outcome
                speculative_ghr <= {speculative_ghr[5:0], predict_taken_wire};
            end
            // else hold speculative_ghr as is
        end
    end

endmodule