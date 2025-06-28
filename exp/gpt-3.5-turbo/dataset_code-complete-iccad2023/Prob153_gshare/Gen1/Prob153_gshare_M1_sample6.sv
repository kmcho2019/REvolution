module gshare_predictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output reg predict_taken,  // Change the output to a reg from wire
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
  reg [6:0] predict_global_history_reg;
  reg [1:0] predict_table[PHT_SIZE-1:0];

  // Registers for training inputs
  reg [6:0] train_global_history_reg;
  reg [1:0] train_table[PHT_SIZE-1:0];

  // Logic to calculate index based on XOR of PC and global history
  wire [INDEX_BITS-1:0] index = {predict_pc, predict_global_history_reg} ^ (predict_global_history_reg >> 1);

  // Prediction logic
  always @* begin
    predict_taken = predict_table[index];
    predict_history = predict_global_history_reg;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      train_table[index] = (train_taken && train_table[index] < 3) ? train_table[index] + 1 :
                           (!train_taken && train_table[index] > 0) ? train_table[index] - 1 : train_table[index];
      train_global_history_reg = train_history;

      if (train_mispredicted) begin
        // Handling misprediction for recovery
        train_global_history_reg <= predict_global_history_reg;
        train_table <= predict_table;
      end
    end
  end

  // Clocked block for updating prediction registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_table[index] <= predict_taken; 
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_taken};
    end
  end

  // Clocked block for updating training registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      train_table <= 0;
      train_global_history_reg <= 0;
    end
  end

endmodule