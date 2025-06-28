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

  // Define a 32-bit shift register for the branch history
  logic [31:0] history_register;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Asynchronous reset
      history_register <= 32'b0;
    end else if (train_mispredicted) begin
      // Load the branch history register with train_history concatenated with train_taken
      history_register <= {train_history, train_taken};
    end else if (predict_valid) begin
      // Shift in predict_taken to update the branch history
      history_register <= {history_register[30:0], predict_taken};
    end
  end

  // Output the branch history
  assign predict_history = history_register;

endmodule