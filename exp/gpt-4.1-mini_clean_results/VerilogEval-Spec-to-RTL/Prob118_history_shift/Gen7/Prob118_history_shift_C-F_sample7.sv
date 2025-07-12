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

    // Update history only when areset or when update occurs to reduce toggling
    wire update_enable = train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Misprediction rollback: load corrected history
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Prediction update: shift in predict_taken at LSB
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else: hold previous history to avoid unnecessary toggling
    end

endmodule