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
    reg [31:0] backup_history;

    // Predict history output follows current_history
    assign predict_history = current_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            backup_history  <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // On misprediction rollback: load corrected history into backup and current
                backup_history  <= {train_history[30:0], train_taken};
                current_history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Save previous state for rollback, then shift in predicted bit
                backup_history  <= current_history;
                current_history <= {current_history[30:0], predict_taken};
            end
            // else hold states
        end
    end

endmodule