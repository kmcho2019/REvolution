module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        predict_history <= 32'd0;
    end else begin
        // Misprediction takes precedence
        if (train_mispredicted) begin
            // Load history from train_history when mispredicted
            predict_history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken when prediction is valid
            predict_history <= {predict_history[30:0], predict_taken};
        end else begin
            // No update condition met, keep current history
            predict_history <= predict_history;
        end
    end
end

endmodule