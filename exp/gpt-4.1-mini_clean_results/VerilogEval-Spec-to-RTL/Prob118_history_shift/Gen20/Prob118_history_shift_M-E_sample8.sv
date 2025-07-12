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
    reg [31:0] prev_history;

    // The output is always the current_history
    assign predict_history = current_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            prev_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Roll back to train_history + actual branch outcome
            current_history <= {train_history[30:0], train_taken};
            prev_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Save current history before updating
            prev_history <= current_history;
            // Shift in predicted outcome
            current_history <= {current_history[30:0], predict_taken};
        end
        // else hold state (no changes)
    end

endmodule