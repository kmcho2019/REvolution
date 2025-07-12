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

    // Pattern History Table: 128 entries, 2-bit saturating counters
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Index calculation for prediction and training
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Current PHT state for prediction (combinational read)
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction output: MSB of counter indicates prediction
    assign predict_taken = predict_counter[1];
    assign predict_history = GHR;

    // Function to update saturating counter based on actual outcome
    function [1:0] saturate_update(input [1:0] counter, input taken);
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weak not taken
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training mispredicted, restore GHR to train_history
            // 2) Else if predict valid, update GHR by shifting in predict_taken
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], predict_taken};
            end
            // else GHR unchanged
        end
    end

endmodule