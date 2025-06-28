module BranchPredictor(
  input clk,
  input areset,

  input predict_valid, predict_taken,
  input [6:0] predict_pc,
  output [6:0] predict_history,

  input train_valid, train_taken, train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  reg [1:0] pattern_history_table [0:127]; // 128-entry PHT
  reg [6:0] global_branch_history;
  reg [6:0] index;

  // Prediction Interface
  always @* begin
    index = predict_pc ^ global_branch_history;
    predict_history = global_branch_history;
  end
  assign predict_taken = pattern_history_table[index] > 1 ? 1 : 0;

  // Training Interface
  always @* begin
    if (train_valid) begin
      index = train_pc ^ train_history;
      if (train_mispredicted) begin
        if (pattern_history_table[index] < 3)
          pattern_history_table[index] <= pattern_history_table[index] + 1;
        global_branch_history <= train_history;
      end else begin
        if (pattern_history_table[index] > 0)
          pattern_history_table[index] <= pattern_history_table[index] - 1;
      end
    end
  end

endmodule