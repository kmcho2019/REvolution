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

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] cnt;
        input       taken;
        begin
            case(cnt)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // weakly not taken
            endcase
        end
    endfunction

    // Predictor state
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    integer i;

    // Combinational indices for prediction and training
    wire [6:0] predict_idx = predict_pc ^ GHR;
    wire [6:0] train_idx = train_pc ^ train_history;

    // Combinational read of PHT entry for prediction index
    wire [1:0] predict_counter = PHT[predict_idx];
    wire       predict_bit = predict_counter[1];  // MSB predicts taken/not taken

    // Combinational predicted taken bit (for speculative update)
    wire       pred_taken = predict_bit;

    // Combinational outputs assigned only on predict_valid clock cycle, registered later
    // This is done inside always @(posedge clk) for synchronization and stable outputs

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                PHT[train_idx] <= saturate_update(PHT[train_idx], train_taken);
            end

            // Register outputs for prediction, capturing GHR and PHT before updates
            if (predict_valid) begin
                predict_taken <= pred_taken;
                predict_history <= GHR;
            end

            // Update GHR with priority:
            // 1) Rollback to train_history if mispredicted training
            // 2) Commit to train_history if training without misprediction
            // 3) Else speculative update with predicted taken
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (train_valid) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], pred_taken};
            end
            // else GHR unchanged
        end
    end

endmodule