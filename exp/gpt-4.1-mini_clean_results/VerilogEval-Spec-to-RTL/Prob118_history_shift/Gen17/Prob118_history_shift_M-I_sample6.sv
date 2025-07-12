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

    // Clock enable to reduce switching when no update is needed
    wire update_en = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_en) begin
            if (train_mispredicted) begin
                // Load corrected history: train_history shifted left by 1, with train_taken as LSB
                history <= {train_history, 1'b0} | 32'b0 | {31'b0, train_taken};
            end else if (predict_valid) begin
                // Shift left by 1 and insert predict_taken at LSB
                history <= {history[30:0], predict_taken};
            end
        end
        // else hold the current history
    end

endmodule