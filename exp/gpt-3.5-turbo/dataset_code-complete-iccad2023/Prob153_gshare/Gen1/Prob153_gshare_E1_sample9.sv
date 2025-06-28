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

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  reg [1:0] predict_table[PHT_SIZE-1:0];
  reg [2:0] predict_state;
  reg [6:0] predict_global_history_reg;
  wire [INDEX_BITS-1:0] predict_index = predict_pc ^ predict_global_history_reg;

  reg [1:0] train_table[PHT_SIZE-1:0];
  reg [6:0] train_global_history_reg;

  // Prediction output registers
  reg predict_taken_output;
  reg [6:0] predict_history_output;

  // Prediction logic
  always @* begin
    predict_taken_output = predict_table[predict_index];
    predict_history_output = predict_global_history_reg;
  end

  // Training logic
  always @* begin
    if (train_valid) begin
      train_table[predict_index] <= (train_taken == 1 && train_table[predict_index] < 3) ? train_table[predict_index] + 1 :
                                    (train_taken == 0 && train_table[predict_index] > 0) ? train_table[predict_index] - 1 : train_table[predict_index];
      train_global_history_reg <= train_history;
    end
  end

  // Clocked block for updating prediction registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_table <= 0;
      predict_state <= 0;
      predict_global_history_reg <= 0;
    end
    else if (predict_valid) begin
      predict_table[predict_index] <= predict_taken_output;
      predict_global_history_reg <= {predict_global_history_reg[5:0], predict_taken_output};
    end
  end

  assign predict_taken = predict_taken_output;
  assign predict_history = predict_history_output;

endmodule