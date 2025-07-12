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

    reg rollback_pending;
    reg [31:0] rollback_history;

    // Prepare rollback history on misprediction, latch it and set flag
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            rollback_pending <= 1'b0;
            rollback_history <= 32'b0;
            predict_history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // On misprediction: store rollback history and set flag
                rollback_history <= {train_history[30:0], train_taken};
                rollback_pending <= 1'b1;
            end else if (rollback_pending) begin
                // Apply rollback history to the register
                predict_history <= rollback_history;
                rollback_pending <= 1'b0;
            end else if (predict_valid) begin
                // Normal prediction shift when no rollback pending
                predict_history <= {predict_history[30:0], predict_taken};
            end
            // else hold predict_history as is
        end
    end

endmodule