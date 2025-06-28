module gshare_predictor (
  input clk,
  input areset,
  input predict_valid,
  input [6:0] predict_pc,
  output reg predict_taken,
  output reg [6:0] predict_history,
  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  // Parameters
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // Predict Registers
  reg [1:0] pattern_history_table[PHT_SIZE-1:0];
  reg [6:0] global_branch_history;
  reg [6:0] predicted_history;

  // Prediction
  always @* begin
    if (predict_valid) begin
      int index = predict_pc ^ global_branch_history;
      predicted_history = global_branch_history;
      predict_taken = (pattern_history_table[index] > 1) ? 1 : 0;
      predict_history = predicted_history;
    end
  end

  // Training
  always @* begin
    if (train_valid) begin
      int train_index = train_pc ^ train_history;
      if (train_mispredicted) begin
        if (pattern_history_table[train_index] < 3) begin
          pattern_history_table[train_index] <= pattern_history_table[train_index] + 1;
        end
        global_branch_history <= train_history;
      end else begin
        if (pattern_history_table[train_index] > 0) begin
          pattern_history_table[train_index] <= pattern_history_table[train_index] - 1;
        end
      end
    end
  end

endmodule