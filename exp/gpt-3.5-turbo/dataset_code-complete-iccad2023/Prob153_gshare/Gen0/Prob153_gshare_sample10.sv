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

  // Constants
  parameter HISTORY_BITS = 7;
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;
  parameter COUNTER_BITS = 2;

  // Branch Predictor data structures
  reg [1:0] pht [0:PHT_SIZE-1];
  reg [6:0] branch_history_register;
  reg [1:0] predict_counter;
  reg [1:0] train_counter;

  // Prediction logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      predict_counter <= 2'b11; // Strongly taken
      branch_history_register <= 7'b0;
    end
    else if (predict_valid) begin
      predict_taken <= predict_counter[1];
      predict_history <= branch_history_register;
    end
  end

  // Training logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      train_counter <= 2'b11; // Strongly taken
    end
    else if (train_valid) begin
      if (train_mispredicted) begin
        pht[train_pc[INDEX_BITS-1:0]] <= train_counter;
        branch_history_register <= train_history;
      end
      train_counter <= (train_taken) ? train_counter + 1 : train_counter - 1;
    end
  end

  // Update Predict Counter based on Global History and PHT
  always @ (*) begin
    predict_counter <= pht[{predict_pc, branch_history_register[6:0]}];
  end

endmodule