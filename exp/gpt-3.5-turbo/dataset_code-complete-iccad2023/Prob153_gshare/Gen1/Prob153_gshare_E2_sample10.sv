module gshare_predictor (
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

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg = 0;
  
  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg = 0;
  
  wire [INDEX_BITS-1:0] index = predict_pc ^ predict_global_history_reg;

  always @* begin
    predict_taken = predict_table[index];
    predict_history = predict_global_history_reg;
  end

  always @* begin
    if (train_valid) begin
      train_table[index] <= (train_taken && train_table[index] < 3) ? train_table[index] + 1 :
                            (!train_taken && train_table[index] > 0) ? train_table[index] - 1 : train_table[index];
      train_global_history_reg <= train_history;
    end
  end

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_taken};
      predict_table[index] <= predict_taken;
    end
  end

endmodule