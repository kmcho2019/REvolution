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

    // PHT: 128-entry 2-bit saturating counters
    // 00 = strongly not taken
    // 01 = weakly not taken
    // 10 = weakly taken
    // 11 = strongly taken
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute prediction index (combinational)
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction outputs (combinational)
    wire predict_taken_wire = predict_counter[1]; // MSB = prediction bit
    assign predict_taken = predict_taken_wire;
    assign predict_history = GHR;

    // Compute training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;

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

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken on reset
        end else begin
            // Update PHT on training only
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority: 
            // if train_mispredicted, restore GHR from train_history (flush)
            // else if prediction valid (and no train_mispredicted), shift in prediction
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit computed combinationally before clock
                GHR <= {GHR[5:0], predict_taken_wire};
            end else begin
                GHR <= GHR; // hold current GHR
            end
        end
    end

endmodule