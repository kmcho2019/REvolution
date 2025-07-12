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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Register to hold the GHR state used for the last valid prediction
    reg [6:0] predict_history_r;

    // Compute indices combinationally
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction counter at current ghr and pc
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction bit is MSB of 2-bit saturating counter (1 = taken)
    assign predict_taken = predict_counter[1];

    // Output the registered predict history (GHR used for last prediction)
    assign predict_history = predict_history_r;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            saturate_update =
                taken ? ((counter == 2'b11) ? 2'b11 : counter + 1)
                      : ((counter == 2'b00) ? 2'b00 : counter - 1);
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_history_r <= 7'b0;
        end else begin
            // Update predict_history_r only when a prediction is valid:
            // it captures the GHR *before* updates in this cycle
            if (predict_valid) begin
                predict_history_r <= ghr;
            end

            // Update PHT on training valid, saturating counter update
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) Training mispredict: recover GHR to train_history
            // 2) Training valid (no mispredict): shift in train_taken
            // 3) Prediction valid: shift in predicted bit (speculative)
            // 4) Else hold GHR unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_counter[1]};
            end
            // else retain ghr
        end
    end

endmodule