module GShareBranchPredictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output reg predict_taken,
  output reg [6:0] predict_history,

  input train_valid,
  input [6:0] train_pc,
  input [6:0] train_history,
  input train_taken,
  input train_mispredicted
);
  
  reg [1:0] pattern_history_table [0:127]; // 128-entry table of 2-bit counters
  reg [6:0] global_branch_history;
  reg [6:0] predicted_history;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      for (int i = 0; i < 128; i = i + 1)
        pattern_history_table[i] <= 2'b11; // Initialize to weakly taken
      global_branch_history <= 0;
    end else begin
      // Prediction logic
      if (predict_valid) begin
        int index = predict_pc ^ global_branch_history;
        predicted_history <= global_branch_history;
        predict_taken <= (pattern_history_table[index] > 1) ? 1 : 0;
        predict_history <= predicted_history;
      end
      
      // Training logic
      if (train_valid) begin
        int train_index = train_pc ^ train_history;
        if (train_mispredicted) begin
          if (pattern_history_table[train_index] < 3)
            pattern_history_table[train_index] <= pattern_history_table[train_index] + 1;
          global_branch_history <= train_history;
        end else begin
          if (pattern_history_table[train_index] > 0)
            pattern_history_table[train_index] <= pattern_history_table[train_index] - 1;
        end
      end
    end
  end

endmodule