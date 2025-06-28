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
  parameter PREDICT_CYCLE_DELAY = 1; // Number of cycles for prediction update delay

  // Registers for prediction interface
  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg;
  reg predict_taken_reg;
  reg [6:0] predict_history_reg;

  // Registers for training inputs
  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;
  reg [6:0] train_pc_reg;
  reg train_taken_reg;
  reg train_history_reg;
  reg train_mispredicted_reg;

  // Logic to calculate index based on XOR of PC and global history
  wire [INDEX_BITS-1:0] predict_index = predict_pc ^ predict_global_history_reg;

  // Prediction logic
  always @* begin
    predict_taken = predict_taken_reg;
    predict_history = predict_history_reg;
  end

  // Training logic
  reg [INDEX_BITS-1:0] train_index;
  always @* begin
    train_index = train_pc_reg ^ train_global_history_reg;
  end

  always @* begin
    if (train_valid && !predict_valid) begin
      predict_taken = train_taken_reg;
      if (train_mispredicted_reg) begin
        train_table[train_index] <= (train_taken_reg == 1 && train_table[train_index] < 3) ? train_table[train_index] + 1 :
                                    (train_taken_reg == 0 && train_table[train_index] > 0) ? train_table[train_index] - 1 : train_table[train_index];
        train_global_history_reg <= train_history_reg;
      end
    end
  end

  // Clocked block for updating prediction registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
      predict_taken_reg <= 0;
      predict_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_history_reg <= predict_global_history_reg;
      predict_taken_reg <= predict_table[predict_index];
    end
  end

  // Clocked block for training updates
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      train_table <= 0;
      train_global_history_reg <= 0;
      train_pc_reg <= 0;
      train_taken_reg <= 0;
      train_history_reg <= 0;
      train_mispredicted_reg <= 0;
    end
    else if (train_valid && !predict_valid) begin
      train_pc_reg <= train_pc;
      train_taken_reg <= train_taken;
      train_history_reg <= train_history;
      train_mispredicted_reg <= train_mispredicted;
    end
  end

endmodule