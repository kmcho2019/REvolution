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

    reg [31:0] next_history;
    reg        update_enable;

    always @(*) begin
        if (train_mispredicted) begin
            // Misprediction rollback has priority: load train_history + train_taken
            next_history = {train_history[30:0], train_taken};
            update_enable = 1'b1;
        end else if (predict_valid) begin
            // Prediction update: shift in predict_taken
            next_history = {predict_history[30:0], predict_taken};
            update_enable = 1'b1;
        end else begin
            // Hold current history
            next_history = predict_history;
            update_enable = 1'b0;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
    end

endmodule