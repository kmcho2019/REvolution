module gshare_predictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output reg predict_taken, // Output changed to a reg to eliminate naming conflict
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

  // Internal registers and wires
  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] predict_global_history_reg, train_global_history_reg;
  reg [INDEX_BITS-1:0] predict_index, train_index;

  // Generate PHT index
  assign predict_index = predict_pc ^ predict_global_history_reg;
  assign train_index = train_pc ^ train_global_history_reg;

  // Prediction logic
  always @* begin
    predict_taken = predict_table[predict_index][1]; // Take MSB of saturating counter
    predict_history = predict_global_history_reg;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      train_table[train_index] <= (train_taken && train_table[train_index] < 3) ? train_table[train_index] + 1 :
                               (!train_taken && train_table[train_index] > 0) ? train_table[train_index] - 1 : train_table[train_index];
      train_global_history_reg <= train_history;
    end
  end

  // Clocked block for updating predict registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_global_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_table[predict_index] <= {predict_table[predict_index][0], predict_taken}; // Update saturating counter
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_taken};
    end
  end

  // Priority encoder to handle conflicts between training and prediction
  always @* begin
    if (train_valid && !predict_valid && train_index == predict_index) begin
      // Training takes precedence
      predict_table[train_index] <= (train_taken && train_table[train_index] < 3) ? train_table[train_index] + 1 :
                                 (!train_taken && train_table[train_index] > 0) ? train_table[train_index] - 1 : train_table[train_index];
      predict_global_history_reg <= train_history;
    end
  end

endmodule