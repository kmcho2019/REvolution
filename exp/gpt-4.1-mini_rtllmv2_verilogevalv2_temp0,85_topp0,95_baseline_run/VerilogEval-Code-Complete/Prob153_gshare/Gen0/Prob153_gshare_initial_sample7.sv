module TopModule (
  input        clk,
  input        areset,

  input        predict_valid,
  input  [6:0] predict_pc,
  output       predict_taken,
  output [6:0] predict_history,

  input        train_valid,
  input        train_taken,
  input        train_mispredicted,
  input  [6:0] train_history,
  input  [6:0] train_pc
);

  // 2-bit saturating counter states
  localparam TAKEN_STRONG   = 2'b11;
  localparam TAKEN_WEAK     = 2'b10;
  localparam NOTTAKEN_WEAK  = 2'b01;
  localparam NOTTAKEN_STRONG= 2'b00;

  // Global History Register (GHR)
  reg [6:0] ghr;

  // Pattern History Table (PHT) with 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Indexes for prediction and training
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Current counter states read from PHT (combinational)
  wire [1:0] predict_counter = pht[predict_index];
  wire [1:0] train_counter   = pht[train_index];

  // Prediction is taken if MSB of 2-bit saturating counter is 1
  assign predict_taken = predict_counter[1];
  assign predict_history = ghr;

  // Next state logic for saturating counter update on training
  function [1:0] saturating_counter_next;
    input [1:0] state;
    input       taken;
    begin
      case(state)
        NOTTAKEN_STRONG: saturating_counter_next = taken ? NOTTAKEN_WEAK : NOTTAKEN_STRONG;
        NOTTAKEN_WEAK:   saturating_counter_next = taken ? TAKEN_WEAK : NOTTAKEN_STRONG;
        TAKEN_WEAK:      saturating_counter_next = taken ? TAKEN_STRONG : NOTTAKEN_WEAK;
        TAKEN_STRONG:    saturating_counter_next = taken ? TAKEN_STRONG : TAKEN_WEAK;
        default:         saturating_counter_next = NOTTAKEN_WEAK; // safe default
      endcase
    end
  endfunction

  integer i;

  // Asynchronous reset and initialization
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= NOTTAKEN_WEAK; // Initialize to weakly not taken
    end else begin
      // Update PHT for training, if valid
      if (train_valid) begin
        // Update PHT entry indexed by train_index
        pht[train_index] <= saturating_counter_next(pht[train_index], train_taken);
      end

      // Update GHR according to priority:
      // If training valid and mispredicted: recover GHR to train_history (state after the mispredicted branch)
      // Else if training valid and not mispredicted: update GHR with actual outcome
      // Else if prediction valid and no training misprediction: update GHR with predicted outcome
      if (train_valid && train_mispredicted) begin
        ghr <= train_history; // recover GHR to state after mispredicted branch
      end else if (train_valid && !train_mispredicted) begin
        // Shift in actual outcome from training
        ghr <= {ghr[5:0], train_taken};
      end else if (predict_valid) begin
        // Shift in predicted outcome from prediction
        ghr <= {ghr[5:0], predict_counter[1]};
      end
      // If none valid, no change to GHR
    end
  end

endmodule