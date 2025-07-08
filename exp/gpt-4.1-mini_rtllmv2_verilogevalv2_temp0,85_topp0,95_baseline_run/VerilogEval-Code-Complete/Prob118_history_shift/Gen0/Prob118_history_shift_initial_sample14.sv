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
      // Rollback: load with history before mispredicted branch + actual result
      // The history before the mispredicted branch is train_history[31:1]
      // The actual result is train_taken, placed in bit 0 (youngest)
      predict_history <= {train_history[31:1], train_taken};
    end else if (predict_valid) begin
      // Shift right by 1, shift in predict_taken at bit 0
      predict_history <= {predict_history[31:1], predict_taken};
    end
    // else hold current state
  end

endmodule