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

  logic [31:0] branch_history_reg;
  
  // Reset the branch history register on asynchronous reset
  always_ff @(posedge areset) begin
    if (areset) begin
      branch_history_reg <= 0;
    end
  end
  
  // Update branch history on prediction
  always_ff @(posedge clk) begin
    if (predict_valid) begin
      branch_history_reg <= {branch_history_reg[30:0], predict_taken};
    end
    else if (train_mispredicted) begin
      branch_history_reg <= {train_history, train_taken};
    end
  end
  
  assign predict_history = branch_history_reg;
  
endmodule