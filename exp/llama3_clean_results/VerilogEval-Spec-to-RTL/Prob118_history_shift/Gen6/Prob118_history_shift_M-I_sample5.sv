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
        predict_history <= 32'd0;
    end else begin
        // Load history from train_history when mispredicted
        if (train_mispredicted) begin
            predict_history <= {train_history, train_taken};
        end 
        // Shift in predict_taken when prediction is valid
        else if (predict_valid) begin
            predict_history <= {predict_history[30:0], predict_taken};
        end 
        // Otherwise, keep the current history
        else begin
            predict_history <= predict_history;
        end
    end
end

endmodule