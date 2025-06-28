module PHT_index_calculation (
  input [6:0] pc,
  input [6:0] global_history,
  output reg [6:0] index
);
  assign index = pc ^ global_history;
endmodule

module gshare_predictor_prediction (
  input [1:0] table [0:127],
  input [6:0] global_history_reg,
  input [6:0] predict_pc,
  output reg taken,
  output reg [6:0] predict_history
);
  wire [6:0] index;
  PHT_index_calculation index_calculation(.pc(predict_pc), .global_history(global_history_reg), .index(index));
  
  always @* begin
    taken = table[index];
    predict_history = global_history_reg;
  end
endmodule

module gshare_predictor_training (
  input [1:0] table [0:127],
  input [6:0] global_history_reg,
  input [6:0] train_history,
  input train_taken,
  input train_mispredicted,
  output reg [1:0] table_out [0:127],
  output reg [6:0] global_history_out
);
  wire [6:0] index;
  PHT_index_calculation index_calculation(.pc(train_pc), .global_history(global_history_reg), .index(index));

  always @* begin
    if (train_valid) begin
      table_out[index] <= (train_taken && table[index] < 3) ? table[index] + 1 :
                         (!train_taken && table[index] > 0) ? table[index] - 1 : table[index];
      global_history_out <= train_history;
    end
  end
endmodule

module TopModule (
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
  reg [1:0] table [0:127];
  reg [6:0] global_history_reg;
  
  gshare_predictor_prediction prediction(.table(table), .global_history_reg(global_history_reg), .predict_pc(predict_pc), .taken(predict_taken), .predict_history(predict_history));
  gshare_predictor_training training(.table(table), .global_history_reg(global_history_reg), .train_history(train_history), .train_taken(train_taken), .train_mispredicted(train_mispredicted), .table_out(table), .global_history_out(global_history_reg));
endmodule