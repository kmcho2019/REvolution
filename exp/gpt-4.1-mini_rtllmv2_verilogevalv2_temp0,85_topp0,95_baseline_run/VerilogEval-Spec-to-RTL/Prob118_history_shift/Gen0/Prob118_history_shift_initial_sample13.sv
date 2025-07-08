module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset on positive edge of areset
        predict_history <= 32'b0;
    end else if (train_mispredicted) begin
        // On misprediction, load with train_history concatenated with train_taken
        // The youngest branch direction at predict_history[0], so train_taken goes to LSB
        predict_history <= {train_history[31:1], train_taken};
    end else if (predict_valid) begin
        // Shift in predict_taken from LSB side
        predict_history <= {predict_history[30:0], predict_taken};
    end
    // else keep predict_history unchanged
end

endmodule