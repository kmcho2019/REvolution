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

    // 2-bit saturating counters states encoding:
    // 2'b00 = Strongly not taken
    // 2'b01 = Weakly not taken
    // 2'b10 = Weakly taken
    // 2'b11 = Strongly taken

    // Pattern History Table: 128 entries of 2-bit counters
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute index for prediction: XOR PC and GHR
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];
    assign predict_taken = predict_counter[1]; // MSB is prediction bit: 1 = taken
    assign predict_history = GHR;

    // Compute index for training: XOR train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] train_counter_next;
    reg [1:0] train_counter_current;

    // Read current train counter from PHT (combinational)
    assign train_counter_current = PHT[train_index];

    // Function to saturate counters on taken/not taken updates
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken; // 1 if branch taken else 0
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

    // For synchronous update of PHT and GHR
    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken on reset
            end
        end else begin
            // Priority:
            // If train_valid & train_mispredicted => train update + restore GHR to train_history
            // Else if train_valid => update PHT entry only, GHR updated by prediction if predict_valid
            // Else if predict_valid => update GHR with prediction outcome

            // First update PHT if training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(train_counter_current, train_taken);
            end

            // Then update GHR:
            // If mispredicted train, restore history
            // else if predict valid and no mispredicted train, update by predicted direction

            if (train_valid && train_mispredicted) begin
                // Restore GHR to train_history after misprediction
                GHR <= train_history;
            end else if (predict_valid) begin
                // Update GHR by shifting in predicted taken bit
                GHR <= {GHR[5:0], predict_taken};
            end
            // Else no GHR update
        end
    end

endmodule