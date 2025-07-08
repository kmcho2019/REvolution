module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Asynchronous reset, synchronous update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Roll back history: {train_taken, train_history[31:1]} is incorrect because train_history is BEFORE the mispredicted branch,
            // we must form the history after the mispredicted branch: that is (train_history << 1) + train_taken.
            // Since train_history[0] is the youngest branch before the mispredicted one,
            // concatenating train_history and train_taken means train_taken is the youngest.
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted branch outcome from LSB side
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else hold current history
    end

endmodule