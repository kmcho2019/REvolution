module BranchPredictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output reg predict_taken,
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

  // Branch predictor state
  reg [1:0] pattern_history_table [0:PHT_SIZE-1]; // 128-entry table of 2-bit counters
  reg [6:0] global_branch_history;

  // Temporary variables for prediction
  reg [1:0] predict_table_value;
  reg [6:0] predicted_global_history;

  // Predict
  always @* begin
    // Calculate index using XOR of pc and global history
    int index = predict_pc ^ global_branch_history;
    predict_table_value = pattern_history_table[index];
    predicted_global_history = global_branch_history;
  end

  // Train
  always @* begin
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

  // Clocked block for updating PHT after training
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      for (int i = 0; i < PHT_SIZE; i = i + 1) begin
        pattern_history_table[i] <= 2'b11; // Initialize to weakly taken
      end
      global_branch_history <= 0;
    end else if (train_valid) begin
      // PHT and history were updated during training
    end
  end

  // Output assignment for prediction
  always @(posedge clk) begin
    if (predict_valid) begin
      predict_taken <= predict_table_value[1];
      predict_history <= predicted_global_history;
    end
  end

endmodule