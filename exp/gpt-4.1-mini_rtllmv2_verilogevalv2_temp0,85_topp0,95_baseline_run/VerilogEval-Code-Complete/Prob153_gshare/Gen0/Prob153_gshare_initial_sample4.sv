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

  // Pattern History Table: 128 entries, 2-bit saturating counters
  // Counter encoding: 2'b00=strongly not taken, 2'b01=weakly not taken
  //                   2'b10=weakly taken, 2'b11=strongly taken
  reg [1:0] pht [0:127];
  reg [6:0] ghr;  // global history register

  // Wires for prediction index and training index
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [1:0] predict_counter = pht[predict_index];

  wire [6:0] train_index = train_pc ^ train_history;
  wire [1:0] train_counter = pht[train_index];

  // Prediction output
  // MSB of 2-bit counter defines taken/not taken
  assign predict_taken = (predict_counter[1] == 1'b1) && predict_valid;
  assign predict_history = ghr;

  // Next GHR value after prediction or training update
  reg [6:0] ghr_next;

  // Next PHT state for training update
  reg [1:0] pht_new_value;

  integer i;

  // Compute next saturating counter value based on actual taken
  function [1:0] saturate_update;
    input [1:0] old_value;
    input taken;
    begin
      case (old_value)
        2'b00: saturate_update = taken ? 2'b01 : 2'b00;
        2'b01: saturate_update = taken ? 2'b10 : 2'b00;
        2'b10: saturate_update = taken ? 2'b11 : 2'b01;
        2'b11: saturate_update = taken ? 2'b11 : 2'b10;
        default: saturate_update = 2'b01; // default weakly not taken
      endcase
    end
  endfunction

  // Temporary registers to hold next PHT state before clock edge
  reg [1:0] pht_next [0:127];

  // Initialize next PHT with current state
  always @(*) begin
    for (i = 0; i < 128; i = i + 1) begin
      pht_next[i] = pht[i];
    end

    if (train_valid) begin
      // Update the PHT entry at train_index with training outcome
      pht_next[train_index] = saturate_update(pht[train_index], train_taken);
    end
  end

  // Predict taken value (for updating GHR) derived from current PHT state
  wire predicted_taken = (predict_counter[1] == 1'b1);

  // Decide next GHR:
  // Priority:
  //   - If training valid and mispredicted: restore GHR to train_history
  //   - Else if predict valid: update GHR with predicted_taken
  //   - Else no change
  always @(*) begin
    if (train_valid && train_mispredicted) begin
      ghr_next = train_history;
    end else if (predict_valid) begin
      ghr_next = {ghr[5:0], predicted_taken};
    end else begin
      ghr_next = ghr;
    end
  end

  // Sequential logic
  integer idx;
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'b0;
      for (idx = 0; idx < 128; idx = idx + 1) begin
        pht[idx] <= 2'b01; // Initialize to weakly not taken
      end
    end else begin
      ghr <= ghr_next;

      // Update PHT on train_valid
      if (train_valid) begin
        pht[train_index] <= pht_next[train_index];
      end
      // No other updates to PHT outside training
    end
  end

endmodule