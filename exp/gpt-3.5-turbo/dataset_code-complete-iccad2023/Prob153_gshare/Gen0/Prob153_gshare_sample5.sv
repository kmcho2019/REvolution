module branch_predictor (
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
  parameter PREDICTOR_SIZE = 128;
  parameter HISTORY_SIZE = 7;

  reg [1:0] predictor_table[PREDICTOR_SIZE - 1:0];
  reg [6:0] global_history;
  reg [1:0] prediction;
  wire [1:0] counter_prediction;

  // Hash function to map pc and global history to index
  reg [INDEX_BITS-1:0] hash_index;
  always @* begin
    hash_index = predict_pc ^ (global_history & 7'b1111111);
  end

  // Predict branch direction
  assign counter_prediction = predictor_table[hash_index];
  assign predict_taken = (counter_prediction >= 2'b10);
  assign predict_history = global_history;

  // Update predictor and history
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 0;
      predictor_table <= 0;
    end else begin
      if (predict_valid) begin
        prediction <= predictor_table[hash_index];
      end
      if (train_valid) begin
        if (train_mispredicted) begin
          predictor_table[hash_index] <= predictor_table[hash_index] - 1;
        end else if (train_taken) begin
          predictor_table[hash_index] <= predictor_table[hash_index] + 1;
        end
        global_history <= {global_history[5:0], train_taken};
      end
    end
  end
endmodule