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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction, rollback to history before the mispredicted branch plus actual result.
            history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // On prediction, shift left and insert predicted taken bit at LSB.
            history <= {history[30:0], predict_taken};
        end
        // else hold the current history
    end

endmodule