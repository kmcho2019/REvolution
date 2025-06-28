module BranchPredictor(
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

  reg [1:0] pattern_history_table [0:127]; // 128-entry table of 2-bit counters
  reg [6:0] global_branch_history;
  reg [6:0] predicted_history;
  reg predict_taken;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset the predictor
      for (int i = 0; i < 128; i = i + 1) begin
        pattern_history_table[i] <= 2'b11; // Initialize to weakly taken
      end
      global_branch_history <= 0;
    end else begin
      // Predict
      if (predict_valid) begin
        // Calculate index using xor of pc and global history
        int index = predict_pc ^ global_branch_history;
        predicted_history <= global_branch_history;
        
        // Retrieve prediction from PHT
        predict_taken <= (pattern_history_table[index] > 1) ? 1 : 0;
      end
      
      // Train
      if (train_valid) begin
        int train_index = train_pc ^ train_history;
        
        if (train_mispredicted) begin
          // Misprediction - update PHT and history
          if (pattern_history_table[train_index] < 3) begin
            pattern_history_table[train_index] <= pattern_history_table[train_index] + 1;
          end
          global_branch_history <= train_history;
        end else begin
          // Correct prediction - update PHT
          if (pattern_history_table[train_index] > 0) begin
            pattern_history_table[train_index] <= pattern_history_table[train_index] - 1;
          end
        end
      end
    end
  end

  assign predict_history = predicted_history;

endmodule