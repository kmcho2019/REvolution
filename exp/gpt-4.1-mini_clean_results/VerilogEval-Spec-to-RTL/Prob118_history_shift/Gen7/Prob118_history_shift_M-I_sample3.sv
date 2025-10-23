module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    // Clock enable: update only when misprediction or prediction is valid
    wire update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Rollback: shift train_history left by 1 bit, insert train_taken as LSB
                // The original problem states rollback history = train_history + train_taken appended,
                // which effectively is {train_history[30:0], train_taken}
                predict_history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in predict_taken for predicted branch
                predict_history <= {predict_history[30:0], predict_taken};
            end
        end
        // else hold state (no toggle)
    end

endmodule