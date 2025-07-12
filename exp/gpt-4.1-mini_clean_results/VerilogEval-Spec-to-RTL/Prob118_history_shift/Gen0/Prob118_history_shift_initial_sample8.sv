module TopModule(
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Misprediction takes precedence: Load history with actual branch outcome concatenated with train_history shifted right by 1
            // The problem states "train_history concatenated with train_taken"
            // The correct interpretation: the new history after the mispredicted branch is train_taken at LSB and the oldest 31 bits from train_history excluding its LSB.
            // But since train_history[0] is youngest branch, actually the new history is {train_taken, train_history[31:1]}.
            predict_history <= {train_taken, train_history[31:1]};
        end else if (predict_valid) begin
            // Shift in the predicted branch from LSB side
            predict_history <= {predict_history[31:1], predict_taken};
        end
    end

endmodule