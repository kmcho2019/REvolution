module BranchPredictor (
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
  parameter HISTORY_BITS = 7;
  parameter PHT_SIZE = 128;
  parameter GH_SIZE = 128;

  reg [HISTORY_BITS-1:0] global_history;
  reg [6:0] pht[PHT_SIZE-1:0];
  reg [1:0] bhr_state;

  assign predict_taken = pht[{predict_pc, global_history}];
  assign predict_history = global_history;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 0;
      for (i = 0; i < PHT_SIZE; i = i + 1) begin
        pht[i] <= 2'b11;
      end
    end else begin
      if (train_valid) begin
        pht[{train_pc, train_history}] <= train_taken ? 
                                       (train_mispredicted ? 
                                         (bhr_state == 0 ? 2'b00 : bhr_state - 2'b01) :
                                         (bhr_state == 3 ? 3 : bhr_state + 2'b01)) : 
                                       (train_mispredicted ? 
                                         (bhr_state == 0 ? 2'b00 : bhr_state - 2'b01) :
                                         (bhr_state < 3 ? 0 : 1));
      end
      if (predict_valid) begin
        bhr_state <= pht[{predict_pc, global_history}];
        global_history <= {global_history[5:0], predict_taken};
      end
    end
  end

endmodule