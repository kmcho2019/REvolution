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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    reg [6:0] GHR;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT counter for prediction combinationally
    wire [1:0] predict_counter = PHT[predict_index];

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

    // Initialize PHT and GHR asynchronously on reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // Weakly not taken
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // If training mispredicted, recover GHR to train_history
            // Else if prediction valid, shift in predicted bit
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                GHR <= {GHR[5:0], predict_counter[1]};
            end
            // Else hold GHR unchanged

            // Register prediction outputs only on predict_valid to hold stable outputs
            if (predict_valid) begin
                predict_taken <= predict_counter[1];
                predict_history <= GHR;
            end
            // Else outputs hold previous values
        end
    end

endmodule