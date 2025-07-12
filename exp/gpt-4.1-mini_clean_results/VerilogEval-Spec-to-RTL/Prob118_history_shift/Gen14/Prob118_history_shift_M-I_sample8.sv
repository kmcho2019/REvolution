module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;

    assign predict_history = history;

    wire update_enable = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            if (train_mispredicted) begin
                // Load corrected history: train_history concatenated with train_taken as LSB
                history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predicted bit at LSB
                history <= {history[30:0], predict_taken};
            end
        end
        // else hold state
    end

endmodule