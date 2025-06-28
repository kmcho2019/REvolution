module gshare_predictor_predict (
  input predict_pc,
  input [6:0] predict_global_history_reg,
  input [1:0] predict_table[PHT_SIZE-1:0],
  output predict_taken,
  output [6:0] predict_history
);

  wire [INDEX_BITS-1:0] index = predict_pc ^ predict_global_history_reg;

  assign predict_taken = predict_table[index];
  assign predict_history = predict_global_history_reg;

endmodule

module gshare_predictor_train (
  input clk,
  input train_valid,
  input [6:0] train_history,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_pc,
  inout [1:0] train_table[PHT_SIZE-1:0],
  inout [6:0] train_global_history_reg
);

  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;

  reg [INDEX_BITS-1:0] train_index;

  always @* begin
    train_index = train_pc ^ train_global_history_reg;
  end

  always @(posedge clk) begin
    if (train_valid) begin
      if (train_taken == 1 && train_table[train_index] < 3)
        train_table[train_index] <= train_table[train_index] + 1;
      else if (train_taken == 0 && train_table[train_index] > 0)
        train_table[train_index] <= train_table[train_index] - 1;

      train_global_history_reg <= train_history;
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

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg;

  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;

  gshare_predictor_predict predict_inst (
    .predict_pc(predict_pc),
    .predict_global_history_reg(predict_global_history_reg),
    .predict_table(predict_table),
    .predict_taken(predict_taken),
    .predict_history(predict_history)
  );

  gshare_predictor_train train_inst (
    .clk(clk),
    .train_valid(train_valid),
    .train_history(train_history),
    .train_taken(train_taken),
    .train_mispredicted(train_mispredicted),
    .train_pc(train_pc),
    .train_table(train_table),
    .train_global_history_reg(train_global_history_reg)
  );

endmodule