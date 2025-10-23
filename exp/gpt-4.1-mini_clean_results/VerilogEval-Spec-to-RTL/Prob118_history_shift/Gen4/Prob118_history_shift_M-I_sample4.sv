module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    // Clock enable signal: update only when misprediction or prediction valid
    wire update_en = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_en) begin
            if (train_mispredicted)
                // Rollback: shift train_history left by 1, insert train_taken at LSB
                // This matches "train_history concatenated with train_taken" to form new 32-bit history
                predict_history <= {train_history[30:0], train_taken};
            else
                // Prediction update: shift left by 1, insert predict_taken at LSB
                predict_history <= {predict_history[30:0], predict_taken};
        end
        // else hold predict_history (no update)
    end

endmodule