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

    // 2-bit saturating counters:
    // 00 Strongly not taken
    // 01 Weakly not taken
    // 10 Weakly taken
    // 11 Strongly taken

    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Combinational read of PHT entry for prediction
    wire [1:0] predict_counter = PHT[predict_index];
    assign predict_taken = predict_counter[1]; // MSB indicates taken/not-taken
    assign predict_history = GHR;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    integer i;
    reg [1:0] pht_next;
    reg [6:0] next_GHR;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // Update PHT entry on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Determine next GHR value with priority:
            // 1) If training mispredicted: restore GHR to train_history
            // 2) Else if prediction valid and no training misprediction: update GHR with predicted taken bit
            // 3) Else hold current GHR

            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                GHR <= {GHR[5:0], predict_taken};
            end else begin
                GHR <= GHR;
            end
        end
    end

endmodule