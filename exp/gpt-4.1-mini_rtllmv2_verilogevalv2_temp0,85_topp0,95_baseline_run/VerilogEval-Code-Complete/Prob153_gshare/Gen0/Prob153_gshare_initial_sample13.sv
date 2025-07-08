module TopModule (
  input             clk,
  input             areset,

  // Prediction interface
  input             predict_valid,
  input      [6:0]  predict_pc,
  output            predict_taken,
  output reg [6:0]  predict_history,

  // Training interface
  input             train_valid,
  input             train_taken,
  input             train_mispredicted,
  input      [6:0]  train_history,
  input      [6:0]  train_pc
);

  // Pattern History Table (PHT) - 128 entries (2^7), 2-bit saturating counters
  // States: 2'b00 = Strong Not Taken, 2'b01 = Weak Not Taken,
  //         2'b10 = Weak Taken,       2'b11 = Strong Taken
  reg [1:0] pht [0:127];

  // Global History Register (GHR) - 7 bits
  reg [6:0] ghr;

  // Wire: prediction index and train index (7-bit)
  wire [6:0] predict_index;
  wire [6:0] train_index;

  // Compute the gshare index: XOR PC[6:0] with GHR[6:0]
  assign predict_index = predict_pc ^ ghr;
  assign train_index   = train_pc   ^ train_history;

  // Predict current PHT counter for prediction index
  wire [1:0] predict_pht_counter = pht[predict_index];

  // Predict taken if the high bit of the saturating counter is 1
  assign predict_taken = (predict_pht_counter[1] == 1'b1) && predict_valid;

  // Next GHR value after prediction update (shift in predict_taken)
  wire [6:0] ghr_predict_next = {ghr[5:0], predict_taken};

  // Next PHT state for training update function
  function [1:0] saturating_update;
    input [1:0] state;
    input       taken;
    begin
      case (state)
        2'b00: saturating_update = taken ? 2'b01 : 2'b00;
        2'b01: saturating_update = taken ? 2'b10 : 2'b00;
        2'b10: saturating_update = taken ? 2'b11 : 2'b01;
        2'b11: saturating_update = taken ? 2'b11 : 2'b10;
        default: saturating_update = 2'b00;
      endcase
    end
  endfunction

  // Training PHT update: next state for the training index
  wire [1:0] train_pht_next = saturating_update(pht[train_index], train_taken);

  integer i;
  // Asynchronous reset and sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset GHR and PHT entries
      ghr <= 7'b0;
      for (i=0; i<128; i=i+1)
        pht[i] <= 2'b01; // Initialize to weak not taken
    end else begin
      // Update PHT entry on training valid
      if (train_valid) begin
        pht[train_index] <= train_pht_next;
      end

      // Update GHR:
      // If training valid and mispredicted -> restore GHR to train_history (state after mispredicted branch)
      // Else if predict_valid and no mispredict training this cycle -> update GHR with prediction
      if (train_valid && train_mispredicted) begin
        // Recover GHR to train_history after mispredicted branch
        ghr <= train_history;
      end else if (predict_valid) begin
        // Update GHR with predicted outcome
        // Only if training mispredict does not take precedence
        ghr <= ghr_predict_next;
      end
      // If neither training mispredict nor prediction valid, GHR remains unchanged
    end
  end

  // Combinational logic to output predict_history = GHR value used for prediction (state before prediction update)
  always @(*) begin
    // The predictor interface returns the GHR before the prediction update
    predict_history = ghr;
  end

endmodule