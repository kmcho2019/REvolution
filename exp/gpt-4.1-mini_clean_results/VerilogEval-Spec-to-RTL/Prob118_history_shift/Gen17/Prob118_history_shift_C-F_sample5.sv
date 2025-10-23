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
    wire       update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Load corrected history on misprediction:
                // (train_history << 1) + train_taken at LSB
                history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in predict_taken on prediction
                history <= {history[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history;

endmodule