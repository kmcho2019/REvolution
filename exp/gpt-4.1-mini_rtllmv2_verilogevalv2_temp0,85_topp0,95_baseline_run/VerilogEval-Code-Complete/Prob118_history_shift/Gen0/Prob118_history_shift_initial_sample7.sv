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

  // Assign output
  assign predict_history = history;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      history <= 32'b0;
    end else if (train_mispredicted) begin
      // Load history before mispredicted branch + actual taken bit
      history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
      // Shift left by 1, shift in predict_taken at LSB
      // predict_history[0] is youngest branch (LSB)
      history <= {history[30:0], predict_taken};
    end
  end

endmodule