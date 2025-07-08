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
  localparam STRONG_NOTTAKEN = 2'b00;
  localparam WEAK_NOTTAKEN   = 2'b01;
  localparam WEAK_TAKEN      = 2'b10;
  localparam STRONG_TAKEN    = 2'b11;

  // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Global history register
  reg [6:0] global_history;

  // Index calculation for prediction: pc XOR global_history
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [1:0] predict_counter = pht[predict_index];
  wire       predict_taken_comb = predict_counter[1]; // MSB indicates taken

  // Index calculation for training: train_pc XOR train_history
  wire [6:0] train_index = train_pc ^ train_history;
  wire [1:0] train_counter = pht[train_index];

  // Output assignments
  assign predict_taken = predict_valid ? predict_taken_comb : 1'b0;
  assign predict_history = predict_valid ? global_history : 7'b0;

  // Next global history candidate values
  wire predicted_outcome = predict_taken_comb; // predicted branch direction

  // Update PHT saturating counter function
  function [1:0] saturating_counter_update;
    input [1:0] old_state;
    input       taken;
    begin
      case (old_state)
        STRONG_NOTTAKEN: saturating_counter_update = taken ? WEAK_NOTTAKEN : STRONG_NOTTAKEN;
        WEAK_NOTTAKEN:   saturating_counter_update = taken ? WEAK_TAKEN   : STRONG_NOTTAKEN;
        WEAK_TAKEN:     saturating_counter_update = taken ? STRONG_TAKEN : WEAK_NOTTAKEN;
        STRONG_TAKEN:   saturating_counter_update = taken ? STRONG_TAKEN : WEAK_TAKEN;
        default:        saturating_counter_update = WEAK_NOTTAKEN; // default fallback
      endcase
    end
  endfunction

  integer i;

  // Initialization and asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset PHT entries to weakly not taken (01)
      for (i=0; i<128; i=i+1) begin
        pht[i] <= WEAK_NOTTAKEN;
      end
      // Reset global history register
      global_history <= 7'b0;
    end else begin
      // Update PHT table on training if valid
      if (train_valid) begin
        // Update the counter for train_index based on train_taken
        pht[train_index] <= saturating_counter_update(train_counter, train_taken);
      end

      // Update global history register
      // Priority: if train_valid && train_mispredicted, recover history from train_history
      // Else if predict_valid, update history with predicted_outcome
      if (train_valid && train_mispredicted) begin
        global_history <= train_history;
      end else if (predict_valid) begin
        // Shift left by 1 and insert predicted outcome at LSB
        global_history <= {global_history[5:0], predicted_outcome};
      end
      // else keep global_history unchanged
    end
  end

endmodule