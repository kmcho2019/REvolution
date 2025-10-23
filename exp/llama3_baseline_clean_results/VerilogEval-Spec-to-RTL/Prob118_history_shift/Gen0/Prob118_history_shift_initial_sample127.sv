module TopModule(
    input               clk,
    input               areset,
    input               predict_valid,
    input               predict_taken,
    input               train_mispredicted,
    input               train_taken,
    input      [31:0]   train_history,
    output reg [31:0]   predict_history
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'd0;
    end else begin
        if (train_mispredicted) begin
            // Load the history register with the correct value after a misprediction
            predict_history <= {train_history, train_taken};
        end else if (predict_valid) begin
            // Shift in the predict_taken value from the LSB side
            predict_history <= {predict_history[30:0], predict_taken};
        end
    end
end

endmodule