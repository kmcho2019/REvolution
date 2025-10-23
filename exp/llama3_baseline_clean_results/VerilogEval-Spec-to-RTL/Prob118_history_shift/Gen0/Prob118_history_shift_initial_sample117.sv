module TopModule (
    input            clk,
    input            areset,
    input            predict_valid,
    input            predict_taken,
    input            train_mispredicted,
    input            train_taken,
    input      [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history;

    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'd0;
        end else if (train_mispredicted) begin
            // Load new history when misprediction occurs
            predict_history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift history to the right and fill the LSB with the predicted branch direction
            predict_history <= {history[30:0], predict_taken};
        end else begin
            predict_history <= history;
        end
    end

    always @(*) begin
        history = predict_history;
    end

endmodule