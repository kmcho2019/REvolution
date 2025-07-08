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

  logic [31:0] history_reg;

  assign predict_history = history_reg;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      history_reg <= 32'b0;
    end else if (train_mispredicted) begin
      // Concatenate train_history (older) with train_taken (youngest)
      history_reg <= {train_taken, train_history[31:1]};
      // Note: The problem states train_history concatenated with train_taken,
      // but train_history is 32 bits. Since the register is 32 bits,
      // we must decide how to do this properly.
      // The problem says "train_history concatenated with train_taken"
      // which implies 33 bits, but the register is 32 bits.
      // The natural interpretation is that train_history is the older 31 bits,
      // and train_taken is the youngest bit.
      // So we take train_history[31:1] as upper 31 bits, and train_taken as LSB.
      // This keeps the history length consistent.
      //
      // Alternatively, if train_history[0] is youngest branch, and we want to prepend train_taken as youngest,
      // then the history after the mispredicted branch should be train_history[31:1] + train_taken at LSB.
      // We'll assume this interpretation.
    end else if (predict_valid) begin
      history_reg <= {history_reg[30:0], predict_taken};
    end
  end

endmodule