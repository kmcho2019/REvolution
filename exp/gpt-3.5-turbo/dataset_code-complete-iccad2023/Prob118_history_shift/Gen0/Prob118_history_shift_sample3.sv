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

  logic [31:0] shiftreg;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      shiftreg <= 0;
    end else begin
      if (predict_valid) begin
        shiftreg <= {shiftreg[30:0], predict_taken};
      end else if (train_mispredicted) begin
        shiftreg <= {train_history, train_taken};
      end
    end
  end

  assign predict_history = shiftreg;

endmodule