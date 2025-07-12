module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load corrected history: upper 31 bits from train_history, youngest bit is train_taken
            predict_history <= {train_history[31:1], train_taken};
        end else if (predict_valid) begin
            // Shift history left and insert predict_taken at LSB
            predict_history <= {predict_history[31:1], predict_taken};
        end
    end

endmodule