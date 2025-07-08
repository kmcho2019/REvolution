module TopModule (
  input        clk,
  input        areset,

  // Prediction interface
  input        predict_valid,
  input  [6:0] predict_pc,
  output       predict_taken,
  output [6:0] predict_history,

  // Training interface
  input        train_valid,
  input        train_taken,
  input        train_mispredicted,
  input  [6:0] train_history,
  input  [6:0] train_pc
);

  // 2-bit saturating counter states:
  // 2'b00: strongly not taken
  // 2'b01: weakly not taken
  // 2'b10: weakly taken
  // 2'b11: strongly taken

  // Pattern History Table: 128 entries (7-bit index)
  reg [1:0] PHT [0:127];

  // Global history register (7 bits)
  reg [6:0] ghist;

  // Wires for indexing PHT for prediction and training
  wire [6:0] predict_index = predict_pc ^ ghist;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Read PHT entries combinationally for prediction and training
  wire [1:0] pht_predict_entry = PHT[predict_index];
  wire [1:0] pht_train_entry   = PHT[train_index];

  // Output predicted taken: MSB of saturating counter
  assign predict_taken = (pht_predict_entry[1] == 1'b1);

  // Output the history used to make prediction (current ghist)
  assign predict_history = ghist;

  // Next global history values (based on prediction or training)
  // For prediction update: shift in predicted branch direction
  wire [6:0] ghist_next_predict = {ghist[5:0], predict_taken};

  // For training update: shift in actual branch outcome
  wire [6:0] ghist_next_train = {train_history[5:0], train_taken};

  // Update logic for saturating counters
  function [1:0] saturating_update;
    input [1:0] state;
    input       taken;
    begin
      case(state)
        2'b00: saturating_update = taken ? 2'b01 : 2'b00;
        2'b01: saturating_update = taken ? 2'b10 : 2'b00;
        2'b10: saturating_update = taken ? 2'b11 : 2'b01;
        2'b11: saturating_update = taken ? 2'b11 : 2'b10;
        default: saturating_update = 2'b00;
      endcase
    end
  endfunction

  integer i;

  // Sequential logic block
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset global history and PHT entries
      ghist <= 7'b0;
      for (i=0; i<128; i=i+1)
        PHT[i] <= 2'b01; // Initialize to weakly not taken to avoid bias
    end else begin
      // Update PHT on train_valid
      if (train_valid) begin
        PHT[train_index] <= saturating_update(PHT[train_index], train_taken);
      end

      // Update global history register:
      // Training takes precedence if both train_valid and predict_valid
      if (train_valid && train_mispredicted) begin
        // Recover history to the state after mispredicted branch completes execution
        // This means set ghist to train_history with actual outcome shifted in
        ghist <= ghist_next_train;
      end else if (train_valid) begin
        // If no misprediction, update history with actual outcome after training
        ghist <= ghist_next_train;
      end else if (predict_valid) begin
        // Update with predicted outcome if no training or training not valid
        ghist <= ghist_next_predict;
      end
      // Else retain the current ghist
    end
  end

endmodule