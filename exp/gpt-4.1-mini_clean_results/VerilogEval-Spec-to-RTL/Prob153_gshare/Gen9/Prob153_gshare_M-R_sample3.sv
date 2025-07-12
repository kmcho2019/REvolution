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
                default: saturate_update = 2'b01; // weakly not taken default
            endcase
        end
    endfunction

    // Pattern History Table (PHT) - 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    integer i;

    // Architectural (committed) global history register
    reg [6:0] arch_ghr;

    // Speculative global history register
    reg [6:0] spec_ghr;

    // Index wires for prediction and training
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    wire [6:0] train_index   = train_pc   ^ train_history;

    // Current PHT counter read for prediction index (combinational)
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction taken if MSB of counter is 1
    assign predict_taken = (predict_valid) ? predict_counter[1] : 1'b0;

    // Predict history output is always the current spec_ghr when predict_valid asserted,
    // else zeros (to avoid latches)
    assign predict_history = (predict_valid) ? spec_ghr : 7'b0;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;
            arch_ghr <= 7'b0;
            spec_ghr <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT entry at train_index
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);

                if (train_mispredicted) begin
                    // On misprediction, rollback both arch and spec GHR to train_history
                    arch_ghr <= train_history;
                    spec_ghr <= train_history;
                end else begin
                    // On correct prediction training, update arch_ghr by shifting in train_taken
                    arch_ghr <= {train_history[5:0], train_taken};
                    // Speculative history also synchronized to arch_ghr (commit)
                    spec_ghr <= {train_history[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // No training this cycle: update spec_ghr speculatively with predicted taken bit
                spec_ghr <= {spec_ghr[5:0], predict_counter[1]};
            end
            // Otherwise hold states unchanged
        end
    end

endmodule