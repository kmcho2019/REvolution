module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] current_history;
    reg [31:0] pre_predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history      <= 32'b0;
            pre_predict_history  <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, rollback current history to train_history + train_taken
            current_history <= {train_history[30:0], train_taken};
            // Buffer doesn't update on rollback
        end else if (predict_valid) begin
            // Save current history before shifting
            pre_predict_history <= current_history;
            // Shift in predict_taken
            current_history <= {current_history[30:0], predict_taken};
        end
        // else hold current values
    end

    assign predict_history = current_history;

endmodule