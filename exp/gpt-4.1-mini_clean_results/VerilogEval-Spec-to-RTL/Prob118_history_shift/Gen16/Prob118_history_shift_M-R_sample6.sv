module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    reg [31:0] next_history;

    // Compute next history value combinationally
    always @(*) begin
        if (train_mispredicted) begin
            // Misprediction: load corrected history = train_history[30:0] concatenated with train_taken at LSB
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Prediction: shift left by 1 and shift in predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // No update
            next_history = predict_history;
        end
    end

    // Sequential update on clock or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= next_history;
        end
    end

endmodule