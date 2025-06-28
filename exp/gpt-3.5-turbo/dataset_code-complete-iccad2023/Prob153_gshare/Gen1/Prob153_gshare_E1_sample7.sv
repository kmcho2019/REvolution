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
  parameter COUNTER_BITS = 2;
  
  // Memory to store 2-bit saturating counters for 128 entries
  reg [COUNTER_BITS-1:0] pht [0:PHT_SIZE-1]; // Dual-port memory

  // Branch history register
  reg [6:0] branch_history_reg;

  // Prediction process
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      branch_history_reg <= 7'b0;
      predict_taken <= 1'b0;
      predict_history <= 7'b0;
    end
    else if (predict_valid) begin
      predict_taken <= pht[predict_pc ^ branch_history_reg][1];
      predict_history <= branch_history_reg;
    end
  end

  // Training process
  always @ (posedge clk or posedge areset) begin
    integer train_index;
    if (areset) begin
      for (train_index = 0; train_index < PHT_SIZE; train_index = train_index + 1) begin
        pht[train_index] <= 2'b11; // Initialize to Strongly Taken
      end
    end
    else if (train_valid) begin
      if (train_mispredicted) begin
        pht[train_pc ^ train_history] <= (train_taken == 1 && pht[train_pc ^ train_history] < 3) ? pht[train_pc ^ train_history] + 1 :
                                        (train_taken == 0 && pht[train_pc ^ train_history] > 0) ? pht[train_pc ^ train_history] - 1 :
                                        pht[train_pc ^ train_history];
      end
      branch_history_reg <= train_history;
    end
  end

endmodule