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

    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entry for prediction combinationally
    wire [1:0] predict_counter = PHT[predict_index];

    assign predict_taken = predict_counter[1];  // MSB = taken bit
    assign predict_history = GHR;

    // Saturating counter update
    function [1:0] saturate_update(input [1:0] counter, input taken);
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

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1) PHT[i] <= 2'b01;  // Weakly not taken
        end else begin
            // Update PHT on training
            if (train_valid)
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);

            // Update GHR with priority
            if (train_valid && train_mispredicted)
                GHR <= train_history;  // Recover GHR on misprediction
            else if (predict_valid)
                GHR <= {GHR[5:0], predict_taken};  // Shift in predicted bit
            // else retain GHR
        end
    end

endmodule