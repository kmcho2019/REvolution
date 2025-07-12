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

reg [31:0] history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        history <= 32'd0;
    end else begin
        // Misprediction takes precedence
        if (train_mispredicted) begin
            // Load history from train_history when mispredicted
            history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken when prediction is valid
            history <= {history[30:0], predict_taken};
        end else begin
            // No update condition met, keep current history
            history <= history;
        end
    end
end

assign predict_history = history;

endmodule