module TopModule (
    input             clk,
    input             areset,
    input             predict_valid,
    input             predict_taken,
    input             train_mispredicted,
    input             train_taken,
    input      [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load the history before mispredicted branch plus actual branch outcome.
            // The youngest branch direction (LSB) is train_taken.
            // Take upper 31 bits of train_history and place train_taken at LSB.
            predict_history <= {train_history[31:1], train_taken};
        end else if (predict_valid) begin
            // Shift right by 1 to make room for the newest prediction at MSB,
            // thus keeping predict_history[0] as youngest branch.
            // Insert predict_taken at MSB.
            predict_history <= {predict_taken, predict_history[31:1]};
        end
    end

endmodule