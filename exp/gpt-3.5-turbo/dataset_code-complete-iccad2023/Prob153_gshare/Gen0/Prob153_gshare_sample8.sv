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

  reg [6:0] global_history = 7'b0;
  reg [6:0] predict_history_reg;
  reg [1:0] pht[0:127]; // Pattern History Table
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      predict_history_reg <= 7'b0;
      for (int i = 0; i < 128; i=i+1) begin
        pht[i] <= 2'b11; // Initialize PHT entries to 'Strongly Taken'
      end
    end
    else begin
      if (predict_valid) begin
        predict_history_reg <= global_history;
        predict_taken <= pht[predict_pc ^ global_history[6:0]][1];
      end

      if (train_valid) begin
        pht[train_pc ^ train_history[6:0]][1] <= train_taken ? (train_mispredicted ? (pht[train_pc ^ train_history[6:0]][1] == 2'b00 ? 2'b00 : pht[train_pc ^ train_history[6:0]][1] - 2'b01) : (pht[train_pc ^ train_history[6:0]][1] == 2'b11 ? 2'b11 : pht[train_pc ^ train_history[6:0]][1] + 2'b01)) : (train_mispredicted ? (pht[train_pc ^ train_history[6:0]][1] == 2'b11 ? 2'b11 : pht[train_pc ^ train_history[6:0]][1] + 2'b01) : (pht[train_pc ^ train_history[6:0]][1] == 2'b00 ? 2'b00 : pht[train_pc ^ train_history[6:0]][1] - 2'b01));
        global_history <= {global_history[5:0], train_taken};
      end
    end
  end

endmodule