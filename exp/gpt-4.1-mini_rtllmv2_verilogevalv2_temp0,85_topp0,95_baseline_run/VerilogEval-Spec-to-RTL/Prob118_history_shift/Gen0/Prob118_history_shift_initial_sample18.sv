module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else if (train_mispredicted) begin
        // load history: upper 31 bits from train_history, LSB from train_taken
        // As per spec, predict_history[0] is youngest branch, so train_taken is LSB
        predict_history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
        // shift left by 1, insert predict_taken at LSB
        predict_history <= {predict_history[30:0], predict_taken};
    end
    // else hold current predict_history
end

endmodule