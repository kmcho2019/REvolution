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

    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Combinational read of PHT entry for prediction
    wire [1:0] predict_counter = PHT[predict_index];

    assign predict_taken = predict_counter[1]; // MSB is prediction bit
    assign predict_history = GHR;

    // Function to saturate counters on taken/not taken updates
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

    // Next GHR value combinational logic
    reg [6:0] next_GHR;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // On mispredicted training, restore GHR to train_history
            next_GHR = train_history;
        end else if (predict_valid) begin
            // Else if prediction valid (and no mispredicted training), shift in predicted taken
            next_GHR = {GHR[5:0], predict_taken};
        end else begin
            // Hold current GHR
            next_GHR = GHR;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken on reset
            end
        end else begin
            // Update PHT on training synchronously
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority to training misprediction restore
            GHR <= next_GHR;
        end
    end

endmodule