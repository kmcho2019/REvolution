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

    // Global History Register
    reg [6:0] GHR;

    // Helper function: saturating counter update
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

    // Combinational index for prediction and train
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_taken_comb = predict_counter[1]; // MSB as taken bit

    wire [6:0] train_index = train_pc ^ train_history;

    // Sequential logic: update PHT, GHR, and outputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // Update PHT on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update outputs only when predict_valid is asserted
            if (predict_valid) begin
                predict_taken <= predict_taken_comb;
                predict_history <= GHR;
            end

            // Update GHR with priority: train_mispredicted recovery else shift in predicted taken
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], predict_taken_comb};
            end
            // Else hold GHR value
        end
    end

endmodule