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

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_history <= 32'b0;
    end else if (train_mispredicted) begin
      // Load history with train_history concatenated with train_taken
      predict_history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
      // Shift left by 1 and insert predict_taken at LSB
      predict_history <= {predict_history[30:0], predict_taken};
    end
  end

endmodule