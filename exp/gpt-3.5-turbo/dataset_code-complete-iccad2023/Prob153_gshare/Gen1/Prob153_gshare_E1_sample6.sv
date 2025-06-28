module GShareBranchPredictor (
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

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  reg [1:0] pattern_history_table[PHT_SIZE-1:0];
  reg [6:0] global_history_register;
  reg [6:0] train_global_history_reg;
  reg train_pc_delayed;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      pattern_history_table <= 2'b11;
      global_history_register <= 0;
    end else begin
      if (predict_valid) begin
        // Calculate index for prediction
        wire [INDEX_BITS-1:0] index_predict = predict_pc ^ global_history_register;
        
        // Predict the branch outcome
        predict_taken <= pattern_history_table[index_predict] > 1 ? 1 : 0;
        predict_history <= global_history_register;
      end
      
      if (train_valid) begin
        // Calculate index for training
        wire [INDEX_BITS-1:0] index_train = train_pc ^ train_global_history_reg;
        
        // Update pattern history table based on branching outcomes
        if (train_mispredicted) begin
          pattern_history_table[index_train] <= (pattern_history_table[index_train] < 3) ? (pattern_history_table[index_train] + 1) : pattern_history_table[index_train];
          global_history_register <= train_global_history_reg;
        end else begin
          pattern_history_table[index_train] <= (pattern_history_table[index_train] > 0) ? (pattern_history_table[index_train] - 1) : pattern_history_table[index_train];
        end
      end
    end
  end

endmodule