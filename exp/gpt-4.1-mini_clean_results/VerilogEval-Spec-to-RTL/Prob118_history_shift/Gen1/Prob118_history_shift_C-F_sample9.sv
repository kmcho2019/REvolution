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

    // Clock enable: update only if misprediction or prediction valid
    wire update_en = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_en) begin
            if (train_mispredicted) begin
                // Load corrected history after misprediction flush
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in predicted taken bit from LSB
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else retain previous predict_history to avoid unnecessary toggling
    end

endmodule