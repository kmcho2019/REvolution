module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history;

// Reset logic
always @(posedge areset) begin
    history <= 32'd0;
end

// Update logic
always @(posedge clk) begin
    if (train_mispredicted) begin
        // Handle misprediction by updating history directly
        history <= {train_history, train_taken};
    end else if (predict_valid) begin
        // Update history based on prediction
        history <= {history[30:0], predict_taken};
    end
end

assign predict_history = history;

endmodule