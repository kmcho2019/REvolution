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

  // Parameters
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // Registers for prediction interface
  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg;

  // Internal wire for prediction logic
  wire [1:0] prediction_result;
  
  // Registers for training inputs
  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;

  // Logic to calculate index based on XOR of PC and global history
  wire [INDEX_BITS-1:0] index = predict_pc ^ predict_global_history_reg;

  // Prediction logic
  assign prediction_result = predict_table[index];
  reg [1:0] predict_result;
  always @* begin
    predict_result = prediction_result;
    predict_taken = prediction_result[1];
    predict_history = predict_global_history_reg;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      train_table[index] = (train_taken == 1 && train_table[index] < 3) ? train_table[index] + 1 :
                           (train_taken == 0 && train_table[index] > 0) ? train_table[index] - 1 : train_table[index];
      train_global_history_reg = train_history;
    end
  end

  // Clocked block for updating tables on misprediction
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
    end
    else if (train_mispredicted) begin
      predict_table[index] <= predict_result > 0 ? predict_result - 1 : 0;
      predict_global_history_reg <= train_global_history_reg;
    end else if (predict_valid) begin
      predict_table[index] <= predict_result < 3 ? predict_result + 1 : 3;
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_result[1]};
    end
  end

endmodule