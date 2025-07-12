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

reg [31:0] prediction_stage;
reg [31:0] misprediction_stage;
reg [31:0] history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        prediction_stage <= 32'd0;
        misprediction_stage <= 32'd0;
        history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            misprediction_stage <= {train_history, train_taken};
            history <= misprediction_stage;
        end else if (predict_valid) begin
            prediction_stage <= {history[30:0], predict_taken};
            history <= prediction_stage;
        end else begin
            history <= history;
        end
    end
end

assign predict_history = history;

endmodule