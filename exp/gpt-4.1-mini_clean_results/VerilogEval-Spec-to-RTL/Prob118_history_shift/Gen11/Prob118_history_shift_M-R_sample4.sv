module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    reg [31:0] next_predict_history;

    // Combinational next state logic
    always @(*) begin
        if (train_mispredicted) begin
            // Misprediction takes priority: concatenate train_history and train_taken
            next_predict_history = {train_history, 1'b0} | {31'b0, train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken on prediction valid
            next_predict_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current value if no update
            next_predict_history = predict_history;
        end
    end

    // Sequential update of the predict_history register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_predict_history;
        end
    end

endmodule