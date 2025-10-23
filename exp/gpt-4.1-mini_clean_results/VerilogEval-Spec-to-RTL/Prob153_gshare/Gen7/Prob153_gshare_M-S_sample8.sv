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
                default: saturate_update = 2'b01; // weakly not taken
            endcase
        end
    endfunction

    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    integer i;

    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // If train_mispredicted, recover GHR from train_history (rollback)
            // Else if train_valid (non-mispredicted), update GHR to train_history (committed)
            // Else if predict_valid and no misprediction recovery, update GHR speculatively with predicted bit
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (train_valid) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], prediction_bit};
            end

            // Register prediction outputs when predict_valid
            if (predict_valid) begin
                predict_taken <= prediction_bit;
                predict_history <= GHR;
            end
            // Otherwise hold outputs stable
        end
    end

endmodule