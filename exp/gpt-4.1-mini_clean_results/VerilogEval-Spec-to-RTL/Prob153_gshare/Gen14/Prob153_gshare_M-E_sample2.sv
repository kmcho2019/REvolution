module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 2-bit saturating counter states for PHT entries
    // 00 = strongly not taken, 01 = weakly not taken,
    // 10 = weakly taken, 11 = strongly taken
    reg [1:0] pht [0:127];

    // Global history register (7-bit)
    reg [6:0] ghr;

    // Prediction pipeline registers for outputs (to align outputs to next cycle)
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Internal wires for prediction index and prediction bit
    wire [6:0] pred_index;
    wire [1:0] pred_counter;
    wire       pred_taken;

    // Compute prediction index by XORing PC with current GHR
    assign pred_index = predict_pc ^ ghr;
    assign pred_counter = pht[pred_index];
    assign pred_taken = pred_counter[1];  // Taken if MSB of saturating counter is 1

    // Outputs are registered versions of prediction results and history
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end

            ghr <= 7'b0;

            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // --- Training update ---
            if (train_valid) begin
                // Compute training index
                // train_history is the GHR state at time of branch resolution
                // XOR with train_pc gives PHT entry to update
                // Since train_history is input, no issues using it combinationally here
                // pht indexed by train_pc ^ train_history
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);

                // If mispredicted, restore GHR to train_history state (branch outcome incorporated)
                // Otherwise, advance GHR by train_taken outcome
                if (train_mispredicted) begin
                    ghr <= train_history;
                end else begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end else begin
                // No training, GHR unchanged so far
                ghr <= ghr;
            end

            // --- Prediction update ---
            // If prediction valid and no misprediction recovery this cycle,
            // advance GHR with predicted outcome bit to keep GHR up to date with speculations
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pred_taken};
            end
            // If misprediction recovery happened, ghr was restored above, do not overwrite

            // Latch prediction outputs and history for next cycle output
            // Note: If predict_valid is low, hold previous outputs stable
            if (predict_valid) begin
                predict_taken_reg <= pred_taken;
                predict_history_reg <= ghr;
            end else begin
                predict_taken_reg <= predict_taken_reg;
                predict_history_reg <= predict_history_reg;
            end
        end
    end

endmodule