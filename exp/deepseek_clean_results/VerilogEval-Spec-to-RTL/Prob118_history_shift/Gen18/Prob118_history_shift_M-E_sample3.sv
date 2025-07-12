module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] speculative_history;
    reg [31:0] confirmed_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            speculative_history <= 32'b0;
            confirmed_history <= 32'b0;
        end else begin
            // Prediction phase - always update speculative history
            if (predict_valid) begin
                speculative_history <= {speculative_history[30:0], predict_taken};
            end

            // Validation phase - update confirmed history
            if (train_mispredicted) begin
                confirmed_history <= {train_history[30:0], train_taken};
                speculative_history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Only update confirmed history when no misprediction occurs
                confirmed_history <= speculative_history;
            end
        end
    end

    // Output is always the speculative history (current prediction state)
    assign predict_history = speculative_history;

endmodule