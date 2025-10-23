module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

reg [31:0] history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset, clear the history
        history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            // If there's a misprediction, load the history with the provided train_history and train_taken
            history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // If a prediction is valid, shift the history and update the LSB with predict_taken
            history <= {history[30:0], predict_taken};
        end
    end
end

// Assign the current history to predict_history
assign predict_history = history;

endmodule