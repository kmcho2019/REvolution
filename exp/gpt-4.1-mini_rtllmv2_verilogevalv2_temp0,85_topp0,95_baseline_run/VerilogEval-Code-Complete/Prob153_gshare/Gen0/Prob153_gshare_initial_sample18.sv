module TopModule (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output reg [6:0] predict_history,

  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  // Parameters
  localparam PHT_SIZE = 128;
  localparam COUNTER_BITS = 2;

  // 2-bit saturating counter states:
  // 2'b00 = Strongly not taken
  // 2'b01 = Weakly not taken
  // 2'b10 = Weakly taken
  // 2'b11 = Strongly taken

  // Pattern History Table (PHT): 128 entries of 2-bit counters
  reg [COUNTER_BITS-1:0] pht [0:PHT_SIZE-1];

  // Global Branch History Register (GHR), 7 bits
  reg [6:0] ghr;

  // Prediction index: XOR of PC and GHR
  wire [6:0] predict_index = predict_pc ^ ghr;
  // Training index: XOR of train_pc and train_history
  wire [6:0] train_index = train_pc ^ train_history;

  // Current counter at prediction index
  wire [1:0] pht_counter_at_predict_index;
  assign pht_counter_at_predict_index = pht[predict_index];

  // Predicted taken if MSB of 2-bit counter is 1
  assign predict_taken = (pht_counter_at_predict_index[1] == 1'b1) && predict_valid;

  // Internal signals for next state
  reg [6:0] ghr_next;
  reg [COUNTER_BITS-1:0] pht_entry_update;

  integer i;

  // Combinational logic for PHT update on training
  function [1:0] saturating_counter_next;
    input [1:0] current;
    input taken; // actual outcome
    begin
      case (current)
        2'b00: saturating_counter_next = taken ? 2'b01 : 2'b00;
        2'b01: saturating_counter_next = taken ? 2'b10 : 2'b00;
        2'b10: saturating_counter_next = taken ? 2'b11 : 2'b01;
        2'b11: saturating_counter_next = taken ? 2'b11 : 2'b10;
        default: saturating_counter_next = 2'b10; // default weakly taken
      endcase
    end
  endfunction

  // Register predict_history combinational output uses current GHR at prediction time
  always @(*) begin
    if (predict_valid)
      predict_history = ghr;
    else
      predict_history = 7'b0;
  end

  // Sequential logic: updates happen on posedge clk or async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Initialize GHR and PHT on asynchronous reset
      ghr <= 7'b0;
      for (i = 0; i < PHT_SIZE; i = i + 1) begin
        pht[i] <= 2'b10; // weakly taken initial state
      end
    end else begin
      // 1) Update PHT if training valid
      if (train_valid) begin
        // Update saturating counter at train_index
        pht[train_index] <= saturating_counter_next(pht[train_index], train_taken);
      end

      // 2) Update GHR
      // Priority: if train_valid and train_mispredicted, restore GHR to train_history
      // else if predict_valid and no misprediction training, update GHR with predicted taken
      if (train_valid && train_mispredicted) begin
        ghr <= train_history;
      end else if (predict_valid) begin
        // update GHR with predicted taken bit (from predict_taken)
        ghr <= {ghr[5:0], predict_taken};
      end
      // else no change to GHR
    end
  end

endmodule