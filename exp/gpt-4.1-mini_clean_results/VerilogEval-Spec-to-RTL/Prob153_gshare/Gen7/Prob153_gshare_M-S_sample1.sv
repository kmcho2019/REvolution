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
    integer i;

    // Global History Register: 7-bit, architectural history updated on train/mispredict or speculatively on predict
    reg [6:0] GHR;

    // Saturating counter update function: 2-bit saturating counters
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

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction combinationally
    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1]; // Taken if MSB=1

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Handle misprediction recovery first (takes precedence over prediction update)
            if (train_valid && train_mispredicted) begin
                // Restore GHR to train_history (architectural history after mispredicted branch)
                GHR <= train_history;
            end else if (predict_valid) begin
                // Speculatively update GHR with predicted bit if no mispredict recovery this cycle
                GHR <= {GHR[5:0], prediction_bit};
            end
            // else GHR holds value

            // Register prediction outputs when predict_valid asserted
            if (predict_valid) begin
                predict_taken <= prediction_bit;
                predict_history <= GHR;
            end
            // else outputs stable
        end
    end

endmodule