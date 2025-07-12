module TopModule(
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
        predict_history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            // Load the branch history register with the history after the completion of the mispredicted branch
            // No change, as this operation is already relatively simple
            predict_history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken from the LSB side to update the branch history for the predicted branch
            // Instead of using the concatenation operator, use a shift operation to reduce combinational logic
            predict_history <= (predict_history >> 1) | (predict_taken << 31);
        end else begin
            // No change, as this operation is already a simple hold
            predict_history <= predict_history;
        end
    end
end

endmodule