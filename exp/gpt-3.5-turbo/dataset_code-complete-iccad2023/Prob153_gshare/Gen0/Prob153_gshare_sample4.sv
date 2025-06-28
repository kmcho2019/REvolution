module TopModule(
  input wire clk,
  input wire areset,

  input wire predict_valid,
  input wire [6:0] predict_pc,
  output reg predict_taken,
  output reg [6:0] predict_history,

  input wire train_valid,
  input wire train_taken,
  input wire train_mispredicted,
  input wire [6:0] train_history,
  input wire [6:0] train_pc
);

  reg [6:0] global_history = 7'd0;
  reg [6:0] predict_index;
  reg [1:0] predict_table [0:127];
  
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'd0;
      predict_index <= 7'd0;
      for (int i = 0; i < 128; i = i + 1)
        predict_table[i] <= 2'd1; // Initialize saturating counters to strongly taken at reset
    end else begin
      if (predict_valid) begin
        predict_index <= predict_pc ^ global_history;
        predict_taken <= predict_table[predict_index] > 1;
        predict_history <= global_history;
      end
      
      if (train_valid) begin
        predict_table[train_pc ^ train_history] <= train_taken ? 
          (train_mispredicted ? $saturate(predict_table[train_pc ^ train_history] - 1, 0, 3) : $saturate(predict_table[train_pc ^ train_history] + 1, 0, 3)) : 
          (train_mispredicted ? $saturate(predict_table[train_pc ^ train_history] + 1, 0, 3) : $saturate(predict_table[train_pc ^ train_history] - 1, 0, 3));
        
        if (train_mispredicted) // Recover branch history register
          global_history <= train_history;          
      end
    end
  end

endmodule