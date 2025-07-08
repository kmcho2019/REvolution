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

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      history_reg <= 32'b0;
    end else begin
      if (train_mispredicted) begin
        // Load history with train_history concatenated with train_taken
        history_reg <= {train_history[30:0], train_taken};
      end else if (predict_valid) begin
        // Shift in predict_taken from LSB side, youngest branch at predict_history[0]
        history_reg <= {history_reg[30:0], predict_taken};
      end
      // else hold history_reg
    end
  end

  assign predict_history = history_reg;

endmodule