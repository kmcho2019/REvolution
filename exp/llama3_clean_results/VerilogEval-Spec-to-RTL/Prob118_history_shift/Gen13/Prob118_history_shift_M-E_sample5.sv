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
reg        update_predict;
reg        update_mispredict;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
        update_predict <= 1'b0;
        update_mispredict <= 1'b0;
    end else begin
        // Stage 1: Detection
        if (predict_valid) begin
            update_predict <= 1'b1;
        end else begin
            update_predict <= 1'b0;
        end
        
        if (train_mispredicted) begin
            update_mispredict <= 1'b1;
        end else begin
            update_mispredict <= 1'b0;
        end
        
        // Stage 2: Update
        if (update_mispredict) begin
            history <= {train_history, train_taken};
        end else if (update_predict) begin
            history <= {history[30:0], predict_taken};
        end else begin
            history <= history;
        end
    end
end

assign predict_history = history;

endmodule