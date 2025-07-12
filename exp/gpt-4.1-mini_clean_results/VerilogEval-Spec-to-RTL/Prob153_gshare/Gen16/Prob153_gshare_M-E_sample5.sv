module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output         predict_taken,
    output [6:0]   predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht_mem [0:127];

    // Global History Registers:
    // ghr_pred: history used for prediction and updated on prediction or training recovery
    reg [6:0] ghr_pred;

    // ghr_train: used to keep last recovered history from training mispredicts
    reg [6:0] ghr_train;

    integer i;

    // Compute indices for prediction and training
    wire [6:0] idx_pred = predict_pc ^ ghr_pred;
    wire [6:0] idx_train = train_pc ^ train_history;

    // Read PHT entry for prediction (combinational)
    wire [1:0] counter_pred = pht_mem[idx_pred];

    // Prediction output logic (valid only if predict_valid)
    assign predict_taken = predict_valid ? counter_pred[1] : 1'b0;
    assign predict_history = predict_valid ? ghr_pred : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1'b1;
            end else begin
                saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1'b1;
            end
        end
    endfunction

    // Synchronous logic: reset, update PHT, update histories
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                pht_mem[i] <= 2'b01;
            end
            ghr_pred <= 7'b0;
            ghr_train <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht_mem[idx_train] <= saturate_update(pht_mem[idx_train], train_taken);
            end

            // Update history registers with priority on misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Recover history after misprediction, overrides prediction update
                ghr_pred <= train_history;
                ghr_train <= train_history;
            end else begin
                // No misprediction recovery
                // If training without mispredict: update ghr_train to latest train history shifted with train_taken
                if (train_valid && !train_mispredicted) begin
                    ghr_train <= {train_history[5:0], train_taken};
                end

                // Update ghr_pred on prediction valid (and no misprediction recovery)
                if (predict_valid) begin
                    // Shift in predicted taken bit into ghr_pred
                    ghr_pred <= {ghr_pred[5:0], counter_pred[1]};
                end
                // Else hold ghr_pred as is
            end
        end
    end

endmodule