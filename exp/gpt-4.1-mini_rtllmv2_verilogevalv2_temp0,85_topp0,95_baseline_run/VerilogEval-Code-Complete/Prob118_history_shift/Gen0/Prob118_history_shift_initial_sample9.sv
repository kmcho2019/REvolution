module TopModule (
  input clk,
  input areset,
  input predict_valid,
  input predict_taken,
  output logic [31:0] predict_history,

  input train_mispredicted,
  input train_taken,
  input [31:0] train_history
);

  logic [31:0] history;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      history <= 32'b0;
    end else if (train_mispredicted) begin
      // train_history is history before mispredicted branch, so update LSB with actual result
      history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
      // Shift left by 1, insert predict_taken at LSB
      history <= {history[30:0], predict_taken};
    end
    // else keep history unchanged
  end

  assign predict_history = history;

endmodule