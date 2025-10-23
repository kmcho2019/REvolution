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

    reg [31:0] history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Rollback history: train_history shifted left by 1, with train_taken at LSB
                // Since train_history[0] is youngest (LSB), shift left by 1 moves all bits older,
                // and the youngest branch (LSB) is train_taken
                history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predict_taken at LSB, shifting history right
                // But since youngest branch is at LSB, shift history right by 1 to make room at LSB
                history <= {history[31:1], predict_taken};
            end else begin
                // Hold current history
                history <= history;
            end
        end
    end

    assign predict_history = history;

endmodule