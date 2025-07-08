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
      // On misprediction, load corrected history:
      // youngest branch at LSB = train_taken
      // older branches shifted left by 1
      predict_history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
      // Shift left by 1, insert predict_taken at LSB
      predict_history <= {predict_history[30:0], predict_taken};
    end
    // else hold current history
  end

endmodule