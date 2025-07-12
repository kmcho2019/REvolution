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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load history before mispredicted branch concatenated with actual taken bit
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predicted branch outcome
            predict_history <= {predict_history[30:0], predict_taken};
        end
        // else hold current value (no change)
    end

endmodule