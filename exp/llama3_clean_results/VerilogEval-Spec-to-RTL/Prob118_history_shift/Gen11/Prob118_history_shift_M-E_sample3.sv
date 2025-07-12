module TopModule(
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
reg [31:0] next_history;

// Pipeline stage for prediction handling
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
    end else begin
        if (predict_valid) begin
            // Update history based on prediction
            history <= {history[30:0], predict_taken};
        end else begin
            history <= history;
        end
    end
end

// Pipeline stage for misprediction handling
always @(posedge clk) begin
    if (train_mispredicted) begin
        // Prioritize misprediction handling
        next_history <= {train_history, train_taken};
    end else begin
        next_history <= history;
    end
end

assign predict_history = next_history;

endmodule