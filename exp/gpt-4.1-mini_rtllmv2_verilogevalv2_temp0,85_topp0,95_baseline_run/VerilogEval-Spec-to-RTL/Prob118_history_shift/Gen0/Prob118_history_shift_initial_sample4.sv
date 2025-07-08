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

    // Asynchronous reset and sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Load rollback history: concatenation of previous history (bits [30:0]) and actual branch outcome
                history <= {train_history[30:0], train_taken};
            end else if (predict_valid) begin
                // Shift history left by one, insert predict_taken at LSB
                history <= {history[30:0], predict_taken};
            end
            // else retain history unchanged
        end
    end

    assign predict_history = history;

endmodule