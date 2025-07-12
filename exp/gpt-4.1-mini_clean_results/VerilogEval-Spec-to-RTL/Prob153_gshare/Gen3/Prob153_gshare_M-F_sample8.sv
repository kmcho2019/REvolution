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

    // Prediction latch registers - hold the prediction outputs stable
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Prediction index for combinational read
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];

    // Training index calculation
    wire [6:0] train_index = train_pc ^ train_history;

    // Function to update saturating counter based on actual outcome
    function [1:0] saturate_update(input [1:0] counter, input taken);
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

    integer i;

    // Outputs driven from registered prediction outputs
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT entries
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01; // weakly not taken
            // Clear prediction outputs
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // On predict_valid, latch prediction outputs for stable output
            if (predict_valid) begin
                predict_history_reg <= GHR;
                predict_taken_reg <= predict_counter[1];
            end

            // Update PHT on train_valid using saturating counters
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training mispredicted, restore GHR to train_history
            // 2) Else if predict_valid, shift in the latched prediction bit
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid) begin
                // Shift in the latched predicted bit to keep GHR consistent
                GHR <= {GHR[5:0], predict_taken_reg};
            end
            // else GHR remains unchanged
        end
    end

endmodule