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

  // PHT: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];
  integer i;

  // Global branch history register (7 bits)
  reg [6:0] ghr;

  // Index calculation function: XOR of PC and history
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [6:0] train_index = train_pc ^ train_history;

  // Read current PHT entries for prediction and training
  wire [1:0] pht_predict_entry = pht[predict_index];
  wire [1:0] pht_train_entry = pht[train_index];

  // Prediction output: taken if MSB of counter is 1
  assign predict_taken = (pht_predict_entry[1] == 1'b1) && predict_valid;
  assign predict_history = ghr;

  // Next GHR value candidates
  wire predicted_bit = pht_predict_entry[1];
  wire predicted_ghr_update = predicted_bit;

  // Next GHR if prediction applies (shift left, insert predicted_bit)
  wire [6:0] ghr_pred_next = {ghr[5:0], predicted_ghr_update};
  // GHR if misprediction training restores history (train_history)
  wire [6:0] ghr_train_next = train_history;

  // Next PHT entry value for training index
  reg [1:0] pht_train_next;

  // Saturating counter update function
  function [1:0] update_counter;
    input [1:0] counter;
    input taken;
    begin
      case (counter)
        2'b00: update_counter = taken ? 2'b01 : 2'b00; // strongly not taken
        2'b01: update_counter = taken ? 2'b10 : 2'b00; // weakly not taken
        2'b10: update_counter = taken ? 2'b11 : 2'b01; // weakly taken
        2'b11: update_counter = taken ? 2'b11 : 2'b10; // strongly taken
        default: update_counter = 2'b10;
      endcase
    end
  endfunction

  // For write enable signals
  wire train_and_pred_same_entry = train_valid && predict_valid && (train_index == predict_index);
  wire train_and_pred_different_entry = train_valid && predict_valid && (train_index != predict_index);

  // Update PHT entry for training at next clock edge
  always @(*) begin
    if (train_valid) begin
      pht_train_next = update_counter(pht_train_entry, train_taken);
    end else begin
      pht_train_next = 2'b00; // dummy, won't be used
    end
  end

  // Sequential logic for PHT and GHR update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Initialize PHT entries to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10;
      ghr <= 7'b0;
    end else begin
      // Update PHT if training valid
      if (train_valid) begin
        pht[train_index] <= pht_train_next;
      end

      // Update GHR with priority to training misprediction recover
      if (train_valid && train_mispredicted) begin
        // Recover GHR to train_history state
        ghr <= ghr_train_next;
      end else if (predict_valid) begin
        // Update GHR with predicted bit (only if no training mispredict in same cycle)
        // If train_valid & train_mispredicted, above branch wins.
        ghr <= ghr_pred_next;
      end
      // else hold GHR stable
    end
  end

endmodule