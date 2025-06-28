module gshare_predictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output [6:0] predict_history,

  input train_valid,
  input [6:0] train_pc,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history
);

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // Prediction interface registers
  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg;
  wire [INDEX_BITS-1:0] predict_index = predict_pc ^ predict_global_history_reg;
  
  // Training interface registers
  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;
  wire [INDEX_BITS-1:0] train_index = train_pc ^ train_global_history_reg;

  // Predict logic
  assign predict_taken = predict_table[predict_index];
  assign predict_history = predict_global_history_reg;

  // Train logic
  always @(posedge clk) begin
    if (train_valid) begin
      if (train_mispredicted) begin
        train_table[train_index] <= (train_taken && train_table[train_index] < 3) ? train_table[train_index] + 1 :
                                   (!train_taken && train_table[train_index] > 0) ? train_table[train_index] - 1 : train_table[train_index];
        train_global_history_reg <= train_history;
      end
    end
  end

endmodule