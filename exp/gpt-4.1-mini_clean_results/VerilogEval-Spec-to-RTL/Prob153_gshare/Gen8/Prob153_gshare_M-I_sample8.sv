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

    // Combinational indices
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT read for prediction is combinational from current GHR and predict_pc
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: initialize PHT and GHR
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on train_valid at clock edge
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Register prediction outputs at clock edge when predict_valid
            // Outputs correspond to current GHR and PHT state before any update
            if (predict_valid) begin
                predict_taken <= predict_bit;
                predict_history <= GHR;
            end

            // Update GHR with priority:
            // 1) If misprediction training, recover GHR to train_history (rollback)
            // 2) Else if training without misprediction, update GHR to train_history (commit)
            // 3) Else if prediction valid, update GHR speculatively with predicted bit
            // 4) Else hold current GHR
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (train_valid) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], predict_bit};
            end
            // else GHR unchanged
        end
    end

endmodule