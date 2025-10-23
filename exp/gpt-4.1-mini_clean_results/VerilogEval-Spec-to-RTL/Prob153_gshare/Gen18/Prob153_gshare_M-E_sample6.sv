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

    // 128-entry Pattern History Table (PHT) with 2-bit saturating counters
    // 2'b00 = Strongly Not Taken
    // 2'b01 = Weakly Not Taken
    // 2'b10 = Weakly Taken
    // 2'b11 = Strongly Taken
    reg [1:0] pht [0:127];

    // Global History Register (GHR), 7 bits
    reg [6:0] ghr;

    integer i;

    // Compute prediction index by XOR of PC and current GHR
    wire [6:0] pred_index = predict_pc ^ ghr;

    // Compute training index by XOR of training PC and training history (branch history when branch executed)
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT counter for prediction index (combinational)
    wire [1:0] pred_counter = pht[pred_index];

    // Predict taken if MSB of saturating counter is 1 (counter >= 2)
    assign predict_taken = predict_valid ? pred_counter[1] : 1'b0;

    // Output the current global history used for this prediction (the ghr before update)
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Saturating counter update function: increment if taken, decrement if not taken, saturate at boundaries
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    saturate_update = counter + 1'b1;
                else
                    saturate_update = 2'b11;
            end else begin
                if (counter != 2'b00)
                    saturate_update = counter - 1'b1;
                else
                    saturate_update = 2'b00;
            end
        end
    endfunction

    // On clock edge: update PHT and GHR according to training and prediction signals
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (2'b01) on reset
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            // Clear global history register
            ghr <= 7'b0;
        end else begin
            // Update PHT entry if training is valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end
            // Update GHR with priority to training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Recover GHR to training history after misprediction
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit into GHR
                // pred_counter[1] = predicted taken bit
                ghr <= {ghr[5:0], pred_counter[1]};
            end
            // else hold GHR (no change)
        end
    end

endmodule