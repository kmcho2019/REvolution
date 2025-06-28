module gshare_predictor (
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

  // Parameters
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // Branch history and PHT table for prediction process
  reg [6:0] predict_global_history_reg;
  reg [PHT_SIZE-1:0] predict_table;

  // Branch history and PHT table for training process
  reg [6:0] train_global_history_reg;
  reg [PHT_SIZE-1:0] train_table;

  // Calculate PHT index based on XOR of PC and global history
  wire [INDEX_BITS-1:0] predict_index = predict_pc ^ predict_global_history_reg;

  // Prediction logic
  always @* begin
    predict_taken = predict_table[predict_index];
    predict_history = predict_global_history_reg;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      if (train_mispredicted) begin
        train_global_history_reg = train_history; // Recover the branch history register
      end
      train_table[predict_index] = (train_taken == 1 && train_table[predict_index] < 3) ? train_table[predict_index] + 1 :
                                  (train_taken == 0 && train_table[predict_index] > 0) ? train_table[predict_index] - 1 : train_table[predict_index];
    end
  end

  // Clocked block for updating prediction registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_table[predict_index] <= predict_taken;
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_taken};
    end
  end

  // Clocked block for training updates
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      train_table <= 0;
      train_global_history_reg <= 0;
    end
    else if (train_valid) begin
      if (!train_mispredicted) begin
        train_table[predict_index] <= (train_taken == 1 && train_table[predict_index] < 3) ? train_table[predict_index] + 1 :
                                     (train_taken == 0 && train_table[predict_index] > 0) ? train_table[predict_index] - 1 : train_table[predict_index];
      end
    end
  end

endmodule