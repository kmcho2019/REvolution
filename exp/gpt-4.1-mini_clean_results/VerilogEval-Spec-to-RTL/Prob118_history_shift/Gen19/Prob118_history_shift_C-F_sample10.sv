module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    reg [31:0] next_history;
    wire update_enable;

    // Determine if update is needed (either misprediction or prediction)
    assign update_enable = train_mispredicted | predict_valid;

    always @(*) begin
        if (train_mispredicted) begin
            // Rollback to train_history concatenated with train_taken
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted taken bit
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state if no update
            next_history = predict_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
        // else hold predict_history (no update)
    end

endmodule