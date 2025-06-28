module gshare_predictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output [6:0] predict_history,
  output predict_taken,

  input train_valid,
  input [6:0] train_pc,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history
);

  reg [1:0] pattern_history_table [0:127]; // 128-entry table of 2-bit saturating counters
  reg [6:0] global_history;
  reg [6:0] predict_global_history;
  reg predict_taken;

  always @* begin
    int index = predict_pc ^ predict_global_history;
    predict_history = predict_global_history;
    
    if (predict_valid) begin
      predict_taken = pattern_history_table[index] > 1 ? 1 : 0;
      predict_global_history = {predict_global_history[5:0], predict_taken};
    end
    
    if (train_valid) begin
      int train_index = train_pc ^ train_history;
      
      if (train_mispredicted) begin
        if (pattern_history_table[train_index] < 3) begin
          pattern_history_table[train_index] = pattern_history_table[train_index] + 1;
        end
        global_history = train_history;
      end else begin
        if (pattern_history_table[train_index] > 0) begin
          pattern_history_table[train_index] = pattern_history_table[train_index] - 1;
        end
      end
    end
  end

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      for (int i = 0; i < 128; i = i + 1) begin
        pattern_history_table[i] = 2'b11; // Initialize to weakly taken
      end
      global_history <= 0;
      predict_global_history <= 0;
      predict_taken <= 0;
      predict_history <= 0;
    end
  end

endmodule