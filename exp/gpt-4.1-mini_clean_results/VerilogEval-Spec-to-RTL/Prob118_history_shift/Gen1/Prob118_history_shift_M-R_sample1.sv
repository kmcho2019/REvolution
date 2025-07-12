module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Combinational next state logic
    reg [31:0] next_predict_history;

    always @(*) begin
        if (train_mispredicted) begin
            // On misprediction rollback, the history is train_history concatenated with actual train_taken
            // Youngest bit at LSB, so train_taken goes to LSB, older bits shifted up
            next_predict_history = {train_taken, train_history[31:1]};
        end else if (predict_valid) begin
            // Shift in the predicted taken bit from LSB side
            next_predict_history = {predict_history[31:1], predict_taken};
        end else begin
            // Hold current history
            next_predict_history = predict_history;
        end
    end

    // Sequential update on clock or reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_predict_history;
    end

endmodule