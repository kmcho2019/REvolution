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
      // Load the history after the mispredicted branch:
      // train_history concatenated with train_taken as LSB
      // train_history is the history before the mispredicted branch, so it occupies bits [31:1].
      predict_history <= {train_history[31:1], train_taken};
    end else if (predict_valid) begin
      // Shift right by 1, insert predict_taken at LSB
      predict_history <= {predict_taken, predict_history[31:1]};
    end
    // else hold current predict_history
  end

endmodule