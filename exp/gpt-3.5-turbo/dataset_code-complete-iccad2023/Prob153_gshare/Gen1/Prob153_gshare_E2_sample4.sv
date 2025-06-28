module GshareBranchPredictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output [6:0] predict_history,

  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  // Parameters
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // PHT table defintion
  reg [1:0] pattern_history_table [0:PHT_SIZE-1];
  reg [6:0] global_branch_history;

  // Prediction logic
  always @* begin
    int index = predict_pc ^ global_branch_history;
    predict_taken = pattern_history_table[index] > 1 ? 1 : 0;
    predict_history = global_branch_history;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      int train_index = train_pc ^ train_history;

      if (train_mispredicted) begin
        pattern_history_table[train_index] <= (pattern_history_table[train_index] < 3) ? pattern_history_table[train_index] + 1 : pattern_history_table[train_index];
        global_branch_history <= train_history;
      end else begin
        pattern_history_table[train_index] <= (pattern_history_table[train_index] > 0) ? pattern_history_table[train_index] - 1 : pattern_history_table[train_index];
      end
    end
  end

endmodule