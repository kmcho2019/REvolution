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
      // Load history before the mispredicted branch concatenated with actual branch result
      // train_history is 32 bits, train_taken is 1 bit, we keep 32 bits total so shift left by 1 and add train_taken LSB
      // But the problem states: history after completion of mispredicted branch = train_history concatenated with train_taken
      // Since predict_history[0] is youngest branch, means LSB is the youngest.
      // So history = {train_taken, train_history[31:1]} would lose bits, so actually to keep 32 bits,
      // we shift train_history left by 1 and set LSB to train_taken.
      // But the problem states "history before the mispredicted branch (train_history) concatenated with the actual result (train_taken)"
      // So the youngest bit is train_taken, older bits are train_history[31:1].
      // So history = {train_history[30:0], train_taken}
      // Wait, 32 bits total: the "history before the mispredicted branch" is 32 bits, so adding the actual result makes 33 bits
      // But our register is 32 bits, so we must drop the oldest bit to keep 32 bits.
      // So the result is: history = {train_history[30:0], train_taken}
      history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
      // Shift history left by 1 and insert predict_taken at LSB
      history <= {history[30:0], predict_taken};
    end
    // Else keep history unchanged
  end

  assign predict_history = history;

endmodule