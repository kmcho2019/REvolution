module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire update_en = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_en) begin
            if (train_mispredicted) begin
                // Misprediction rollback has priority
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in predicted taken bit on prediction
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else hold current history to minimize toggling
    end

endmodule